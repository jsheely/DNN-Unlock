<%@ Page Language="C#" AutoEventWireup="true" %>

<%@ Import Namespace="System.Collections.Generic" %>
<%@ Import Namespace="System.Linq" %>

<script runat="server">

    public string ResultJson { get; set; }
    
    protected void Page_Load(object sender, EventArgs e)
    {
        if (!Page.IsPostBack) BindUsers();
    }

    public static List<UserInfo> GetUsers()
    {
        return UserController.GetUsers(-1).ToArray().Cast<UserInfo>().Where(u => u.IsSuperUser).Take(25).ToList();
    }

    protected void showUsers_OnClick(object sender, EventArgs e)
    {
        BindUsers();
    }

    private void BindUsers()
    {
        rptUsers.DataSource = GetUsers();
        rptUsers.DataBind();
    }

    protected void createUser_OnClick(object sender, EventArgs e)
    {

        try
        {
            var user = new UserInfo { Username = cp_Username.Text, IsSuperUser = true };
            user.Membership.Approved = true;
            user.Membership.Password = cp_Password.Text;
            UserController.CreateUser(ref user);


            ResultJson = String.Format("{{ Message: 'User has been created', Status: 'Success' }}");
            BindUsers();
        }
        catch (Exception ex)
        {
            ResultJson = string.Format("{{ Message: '{0}', Status: 'Error' }}", ex.Message.Replace("'", "\""));
        }
    }

    protected void changePassword_OnClick(object sender, EventArgs e)
    {
        try
        {
            MembershipUser user = Membership.GetUser(cp_Username.Text);

            user.ChangePassword(user.ResetPassword(), cp_Password.Text);
            ResultJson = String.Format("{{ Message: 'Password has been changed', Status: 'Success' }}");
        }
        catch (Exception ex)
        {
            ResultJson = string.Format("{{ Message: '{0}', Status: 'Error' }}", ex.Message.Replace("'", "\""));
        }

    }

    protected void getPassword_OnClick(object sender, EventArgs e)
    {

        try
        {
            MembershipUser user = Membership.GetUser(cp_Username.Text);
            var password = user.GetPassword();
            ResultJson = string.Format("{{ Message: '{0}', Status:  'Success' }}", string.Format("Password for user <strong>{0}</strong> is: <strong>{1}</strong>", user.UserName, password));
        }
        catch (Exception ex)
        {
            ResultJson = string.Format("{{ Message: '{0}', Status: 'Error' }}", ex.Message.Replace("'", "\""));
        }



    }

</script>


<!DOCTYPE html>

<html xmlns="http://www.w3.org/1999/xhtml">
<head runat="server">
    <title>Unlock DNN</title>

    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/css/bootstrap.min.css" />
    <link rel="stylesheet" href="//maxcdn.bootstrapcdn.com/font-awesome/4.1.0/css/font-awesome.min.css" />

    <style>
        .menu {
            background-color: #2A2E37;
        }

        .logo {
            font-size: 2em;
            color: #fff !important;
        }

        .left-rail {
            background-color: #E8E8EC;
        }

        .bs-callout {
            display: none;
            padding: 10px;
            margin: 10px 0;
            border: 1px solid #EEE;
            border-left-width: 5px;
            border-radius: 3px;
        }

        .bs-callout-success {
            border-left-color: #5CB85C;
        }

        .bs-callout-error {
            border-left-color: #D9534F;
        }


        .margin-bottom-20 {
            margin-bottom: 20px;
        }

        .username-item {
            cursor: pointer;
        }

            .username-item:hover {
                background-color: #428BCA;
                color: #ffffff;
            }

            .username-item i {
                margin-right: 10px;
            }
    </style>

</head>
<body>
    <form id="form1" runat="server">
        <div>

            <nav class="navbar navbar-inverse menu navbar-static-top" role="navigation">
                <div class="container">
                    <div class="navbar-header">
                        <a class="navbar-brand logo" href="<%= ResolveUrl("~/UnlockDNN.aspx") %>">Unlock DNN</a>
                    </div>
                    <div class="collapse navbar-collapse" id="bs-example-navbar-collapse-5">
                        <p class="navbar-text navbar-right">by <a href="http://twentytech.net" class="navbar-link">Jonathan Sheely</a></p>
                    </div>
                </div>
            </nav>

            <div class="container">
                <div class="row margin-bottom-20">
                    <div class="col-md-12">
                        <div class="bs-callout">
                        </div>


                    </div>
                </div>
                <div class="row margin-bottom-20">
                    <div class="col-md-6 text-center">
                        <h3>Reset/Create User</h3>

                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-addon"><i class="fa fa-user"></i></div>
                                <asp:TextBox runat="server" ID="cp_Username" CssClass="form-control username" placeholder="Enter username"></asp:TextBox>
                            </div>
                        </div>


                        <div class="form-group">
                            <div class="input-group">
                                <div class="input-group-addon"><i class="fa fa-lock"></i></div>
                                <asp:TextBox runat="server" ID="cp_Password" TextMode="Password" CssClass="form-control" placeholder="Enter Password"></asp:TextBox>
                            </div>
                        </div>

                        <asp:Button runat="server" ID="changePassword" OnClick="changePassword_OnClick" Text="Change Password" CssClass="btn btn-large btn-success" />
                        OR
                        <asp:Button runat="server" ID="createUser" Text="Create New User" OnClick="createUser_OnClick" CssClass="btn btn-large btn-success" />
                        OR
                        <asp:Button runat="server" ID="getPassword" Text="Get Password" OnClick="getPassword_OnClick" CssClass="btn btn-large btn-default" />


                    </div>

                    <div class="col-md-6 text-center">
                        <h3>Top 25 List of Super Users</h3>
                        <small>(Select user to pre-fill username field.)</small>
                        <asp:Repeater runat="server" ID="rptUsers">
                            <HeaderTemplate>
                                <ul class="list-unstyled text-left" id="lstUsers">
                            </HeaderTemplate>
                            <ItemTemplate>
                                <li class="list-group-item username-item"><i class="fa fa-user"></i><%# Eval("Username") %></li>
                            </ItemTemplate>
                            <FooterTemplate>
                                </ul>
                            </FooterTemplate>
                        </asp:Repeater>

                    </div>


                </div>
            </div>
        </div>
    </form>


    <script type="text/javascript" src="//cdnjs.cloudflare.com/ajax/libs/jquery/2.1.1/jquery.min.js"></script>
    <script type="text/javascript" src="//maxcdn.bootstrapcdn.com/bootstrap/3.2.0/js/bootstrap.min.js"></script>

    <script type="text/javascript">
        (function ($) {
            $("#lstUsers li").bind('click', function () {
                $(".username").val($(this).text());
                $('html, body').animate({
                    scrollTop: $("body").offset().top
                }, 1000);
            });


            var result = <%= String.IsNullOrEmpty(ResultJson) ? "''" : ResultJson %>;
            if (result) {
                $(".bs-callout").append( $("<h4 />").text(result.Status));
                $(".bs-callout").append($("<p />").html(result.Message));

                if (result.Status == "Success") $('.bs-callout').addClass('bs-callout-success').show();
                if (result.Status == "Error") $('.bs-callout').addClass('bs-callout-error').show();
            }


        })(jQuery);

    </script>


</body>
</html>
