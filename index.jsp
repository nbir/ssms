<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/loginPage.css">
<%@ include file="include/bodyHead" %>


<%
if(request.getParameter("invalid")!=null && Integer.parseInt(request.getParameter("invalid"))==2)
{
%>
	<div class="div_notification">
		<p class="p_error">Invalid username or password. Please try again.</p>
	</div>
<%
}
else if(request.getParameter("success")!=null && Integer.parseInt(request.getParameter("success"))==1)
{
%>
	<div class="div_notification">
		<p class="p_success">Your space has been successfuly booked.</p>
	</div>
<%
}
%>

<div id="div_bodyleft">
		<p class="p_abcabout">ABC Corp. is a Carrying and Forwarding agent. ABC provides manufactures to store their goods before leaving for the wholesale market.
		</p>
		<p class="p_abcabout">Business at ABC it trust-worthy and reliable. ABC supports a complete automated system for managing the sorage. Manufacturers can login at anytime to view detailes about their stored goods.
		</p>
		<p class="p_abcabout">To book space for storage with ABC Corp., please <a href="companyRegister.jsp" id="a_register">register</a>.
		</p>
	</div>
	<div id="div_bodyright">
		<br />
		<form name="form_login" method="post" action="login.jsp">
			<p class="p_loginform">&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;Please enter your login details.</p>
			<p class="p_loginform">Username :<input type="text" name="username" class="input_login" tabindex=1 /></p>
			<p class="p_loginform">Password &nbsp;:<input type="password" name="password" class="input_login" tabindex=2 /></p>
			<p class="p_loginbutton"><input type="submit" value="Login" class="input_loginbutton" tabindex=3 />
			<input type="reset" value="Clear" class="input_loginbutton" tabindex=4 /></p>
		</form>
		<br />
	</div>

<%@ include file="include/pageFoot" %>
