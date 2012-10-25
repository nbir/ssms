<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%@ page import="java.util.Calendar"%>
<%@ page import="java.text.SimpleDateFormat"%>
<%!
    public String getDate(String dateFormat)
	{	//yyyy-MM-dd HH:mm
		Calendar cal = Calendar.getInstance();
		SimpleDateFormat sdf = new SimpleDateFormat(dateFormat);
		return sdf.format(cal.getTime());
	}
%>

<%
if(request.getParameter("store") != null)
{
%>
<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/store.css">
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
		case 4:
		%>
			<div class="div_notification">
				<p class="p_error">Space not available.</p>
			</div>
		<%
		break;
		case 7:
		%>
			<div class="div_notification">
				<p class="p_error">Transaction ID doesn't match with company name, or already dispatch sent out.</p>
			</div>
		<%
		break;
		case 9:
		%>
			<div class="div_notification">
				<p class="p_error">Invalid Transaction ID.</p>
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
				<p class="p_success">Dispatch coming in registered. Transaction ID is <%= request.getParameter("transid") %></p>
			</div>
		<%
		break;
		case 2:
		%>
			<div class="div_notification">
				<p class="p_success">Dspatch going out registered.</p>
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
		<p class="p_message">Please enter the dispatch details and click Submit.</p>
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Dispatch coming in:</p>
		</div>
		
		<br /><br />
		<form name="form_dispatchin" method="post" action="storeDispatchIn.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Company Name</p></div>
				<div class="div_input">
					<select name="companyid" class="input_text" tabindex=1>
					<%
						ResultSet rs = stmt.executeQuery("select companyid, companyname from company");
						while(rs.next())
						{	
					%>
							<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
					<%
						}
					%>
					</select>
				</div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Dispatch Code</p></div>
				<div class="div_input"><input type="text" name="dispatchcode" maxlength="15" class="input_text" tabindex=2 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Dispatch Name</p></div>
				<div class="div_input"><input type="text" name="dispatchname" maxlength="20" class="input_text" tabindex=3 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Space Required</p></div>
				<div class="div_input"><input type="text" name="spacereq" maxlength="10" class="input_text" tabindex=4 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">In date (yyyy-mm-dd)</p></div>
				<div class="div_input"><input type="text" name="indate" value="<%= getDate("yyyy-MM-dd") %>" maxlength="10" class="input_text" tabindex=5 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="hidden" name="userid" value="<%= request.getParameter("userid") %>" />
					<input type="submit" value="Submit" class="input_button" tabindex=6 />
					<input type="reset" value="Clear" class="input_button" tabindex=7 />
				</div>
			</div>
		</form>
		<br />
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Dispatch goin out:</p>
		</div>
		
		<br /><br />
		<form name="form_dispatchout" method="post" action="storeDispatchOut.jsp">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Company Name</p></div>
				<div class="div_input">
					<select name="companyid" class="input_text" tabindex=8>
					<%
						rs = stmt.executeQuery("select companyid, companyname from company");
						while(rs.next())
						{	
					%>
							<option value="<%= rs.getString(1) %>"><%= rs.getString(2) %></option>
					<%
						}
					%>
					</select>
				</div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Transaction ID</p></div>
				<div class="div_input"><input type="text" name="transid" maxlength="10" class="input_text" tabindex=9 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Out date (yyyy-mm-dd)</p></div>
				<div class="div_input"><input type="text" name="outdate" value="<%= getDate("yyyy-MM-dd") %>" maxlength="10" class="input_text" tabindex=10 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="hidden" name="userid" value="<%= request.getParameter("userid") %>" />
					<input type="submit" value="Submit" class="input_button" tabindex=11 />
					<input type="reset" value="Clear" class="input_button" tabindex=12 />
				</div>
			</div>
		</form>
		<br />
	</div>
	
<%
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
