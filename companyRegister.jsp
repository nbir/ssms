<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/companyRegister.css">
<%@ include file="include/bodyHead" %>

	<div id="div_link">
		<form action="index.jsp" method="post">
			<input type="submit" class="input_button" value="Home" />
		</form>
	</div>
	
<%
if(request.getParameter("invalid")!=null)
{
	switch(Integer.parseInt(request.getParameter("invalid")))
	{
		case 1:
		%>
			<div class="div_notification">
				<p class="p_error">Fields cannot be left empty.</p>
			</div>
		<%
		break;
		case 2:
		%>
			<div class="div_notification">
				<p class="p_error">Username already used. Please try another.</p>
			</div>
		<%
		break;
		case 5:
		%>
			<div class="div_notification">
				<p class="p_error">Enter a valid Required Space.</p>
			</div>
		<%
		break;
	};
}

	try /*including driver clasd*/
	{
		Class.forName("com.ibm.db2.jcc.DB2Driver");
	}
	catch (ClassNotFoundException cnfe)
	{ }
	
	int totalSpace=0, usedSpace=0;
	try
	{	/*creating connection*/
	    Connection con=null;
		%>	
			<%@ include file="include/dbcon.jspf" %>
		<%
		
		%>	
			<%@ include file="include/totalSpace.jspf" %>
		<%
		
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("select sum(spacereq) from company");
		rs.next();
		
		String _usedSpace=rs.getString(1);
		if(_usedSpace != null)
			usedSpace=Integer.parseInt(_usedSpace);
		
		rs.close();
		stmt.close();
		con.close();
	}
	catch (SQLException sqle)
	{}
%>

	<div id="div_bodyleft">
		<p class="p_message">Please enter your company details and click Submit. All fields are necessary.</p>
		<p class="p_message">Username and password cannot be more than 15 letters.</p>
		<p class="p_message">Required space should be less than available space. Space available is 
		<%= totalSpace-usedSpace %>
		square meters.</p>
	</div>
	
	<div id="div_bodyright">
		<br />
		<form name="form_login" method="post" action="companyRegisterSubmit.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Company Name</p></div>
				<div class="div_input"><input type="text" name="companyname" maxlength="30" class="input_text" tabindex=1 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Username</p></div>
				<div class="div_input"><input type="text" name="username" maxlength="15" class="input_text" tabindex=2 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Password</p></div>
				<div class="div_input"><input type="password" name="password" maxlength="15" class="input_text" tabindex=3 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Email</p></div>
				<div class="div_input"><input type="text" name="email" maxlength="50" class="input_text" tabindex=4 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Space Required</p></div>
				<div class="div_input"><input type="text" name="spacereq" maxlength="10" class="input_text" tabindex=5 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="hidden" name="availSpace" value="<%= totalSpace-usedSpace %>" />
					
					<input type="submit" value="Submit" class="input_button" tabindex=6 />
					<input type="reset" value="Clear" class="input_button" tabindex=7 />
				</div>
			</div>
		</form>
		<br />
	</div>

<%@ include file="include/pageFoot" %>
