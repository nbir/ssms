<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
if(request.getParameter("admin")!=null)
{
%>
<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/admin.css">
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
		case 0:
		%>
			<div class="div_notification">
				<p class="p_error">Fields cannot be left empty.</p>
			</div>
		<%
		break;
		case 6:
		%>
			<div class="div_notification">
				<p class="p_error">Username already used.</p>
			</div>
		<%
		break;
	};
}

if(request.getParameter("success")!=null)
{
	switch(Integer.parseInt(request.getParameter("success")))
	{
		case 1:
		%>
			<div class="div_notification">
				<p class="p_success">Password successfully changed.</p>
			</div>
		<%
		break;
		case 2:
		%>
			<div class="div_notification">
				<p class="p_success">User successfully created.</p>
			</div>
		<%
		break;
		case 3:
		%>
			<div class="div_notification">
				<p class="p_success">User successfully deleated.</p>
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
	
	try
	{	/*creating connection*/
	    Connection con=null;
		%>	
			<%@ include file="include/dbcon.jspf" %>
		<%
		
		Statement stmt = con.createStatement();
%>

	<div id="div_bodyleft">
		<p class="p_message">This is the administrator page.</p>
		<p class="p_message">To change the password for any user, select the username from the drop down box, enter new password and click on Submit.</p>
		<p class="p_message">To create a new user, select user type, enter username and password, and click on Submit.</p>
		<p class="p_message">To delete an new user, select the username from the drop down box and click on Submit.</p>
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Change Password:</p>
		</div>
		
		<br /><br />
		<form name="form_changepass" method="post" action="adminChangePass.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Username</p></div>
				<div class="div_input">
					<select name="username" class="input_text" tabindex=1>
					<%
						String username="";
						ResultSet rs = stmt.executeQuery("select username from login");
						while(rs.next())
						{
							username=rs.getString(1);
					%>
							<option value="<%= username %>"><%= username %></option>
					<%
						}
					%>
					</select>
				</div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">New password</p></div>
				<div class="div_input"><input type="password" name="password" maxlength="15" class="input_text" tabindex=2 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="submit" value="Submit" class="input_button" tabindex=3 />
					<input type="reset" value="Clear" class="input_button" tabindex=4 />
				</div>
			</div>
		</form>
		<br />
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Create new user:</p>
		</div>
		
		<br /><br />
		<form name="form_createuser" method="post" action="adminCreateUser.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">User type</p></div>
				<div class="div_input">
					<select name="usertype" class="input_text" tabindex=5>
						<option value="1">Administrator</option>
						<option value="2">Manager</option>
						<option value="3">Store Keeper</option>
					</select>
				</div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Username</p></div>
				<div class="div_input"><input type="text" name="username" maxlength="15" class="input_text" tabindex=6 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Password</p></div>
				<div class="div_input"><input type="password" name="password" maxlength="15" class="input_text" tabindex=7 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="submit" value="Submit" class="input_button" tabindex=8 />
					<input type="reset" value="Clear" class="input_button" tabindex=9 />
				</div>
			</div>
		</form>
		<br />
	</div>

	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Delete an user:</p>
		</div>
		
		<br /><br />
		<form name="form_deleteuser" method="post" action="adminDeleteUser.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Username</p></div>
				<div class="div_input">
					<select name="username" class="input_text" tabindex=10>
					<%
						rs = stmt.executeQuery("select username from login where usertype!=4");
						while(rs.next())
						{
							username=rs.getString(1);
					%>
							<option value="<%= username %>"><%= username %></option>
					<%
						}
					%>
					</select>
				</div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="submit" value="Submit" class="input_button" tabindex=11 />
					<input type="reset" value="Clear" class="input_button" tabindex=12 />
				</div>
			</div>
		</form>
		<br />
	</div>

<%
		rs.close();
		stmt.close();
		con.close();
	}
	catch (SQLException sqle)
	{}
%>

<%@ include file="include/pageFoot" %>
<%
}
else
{
%>
	<jsp:forward page="/index.jsp" />
<%
}
%>
