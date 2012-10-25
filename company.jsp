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
if(request.getParameter("company") !=null)
{
%>
<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/company.css">
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
				<p class="p_error">No dispatch exist in given time period.</p>
			</div>
		<%
		break;
		case 1:
		%>
			<div class="div_notification">
				<p class="p_error">Fields cannot be left empty.</p>
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
	
	String companyName="";
	int bookedSpace=0, usedSpace=0, noOfDispatch=0;
	try
	{	/*creating connection*/
	    Connection con=null;
		%>	
			<%@ include file="include/dbcon.jspf" %>
		<%
		
		Statement stmt = con.createStatement();
		ResultSet rs = stmt.executeQuery("select companyname, spacereq from company where companyid="+Integer.parseInt(request.getParameter("userid")));
		if(rs.next())
		{
			companyName=rs.getString(1);
			bookedSpace=Integer.parseInt(rs.getString(2));
		}
		
		rs = stmt.executeQuery("select sum(spacereq), count(*) from store where companyid="+Integer.parseInt(request.getParameter("userid"))+" and outdate is null");
		if(rs.next())
		{
			String _usedSpace=rs.getString(1);
			if(_usedSpace!=null)
				usedSpace=Integer.parseInt(_usedSpace);
			noOfDispatch=Integer.parseInt(rs.getString(2));
		}
		
		rs.close();
		stmt.close();
		con.close();
	}
	catch (SQLException sqle)
	{}

%>

	<div id="div_bodyleft">
		<p class="p_message">Welcome to your page. Here you can find all details about your company's booked storage.</p>
		<p class="p_message">To generate a report, enter from and to date and click on Submit.</p>
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Details:</p>
		</div>
		
		<br /><br />
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Company Name</p></div>
				<div class="div_input"><p class="p_registerform"><%= companyName %></p></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Space booked</p></div>
				<div class="div_input"><p class="p_registerform"><%= bookedSpace %></p></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Space Used</p></div>
				<div class="div_input"><p class="p_registerform"><%= usedSpace %></p></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">Space Available</p></div>
				<div class="div_input"><p class="p_registerform"><%= bookedSpace-usedSpace %></p></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">No. of dispatched</p></div>
				<div class="div_input"><p class="p_registerform"><%= noOfDispatch %></p></div>
			</div>
			
		<br />
	</div>
	
	<div class="div_bodyright">
		<div class="div_heading">
			<p class="p_heading">Generate Report:</p>
		</div>
		
		<br /><br />
		<form name="form_dispatchreport" action="companyReport.jsp" method="post" target="_blank">
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">From date (yyyy-mm-dd)</p></div>
				<div class="div_input"><input type="text" name="fromdate" maxlength="10" value="2005-01-01" class="input_text" tabindex=1 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_label"><p class="p_registerform">To date (yyyy-mm-dd)</p></div>
				<div class="div_input"><input type="text" name="todate" maxlength="10" value="<%= getDate("yyyy-MM-dd") %>" class="input_text" tabindex=2 /></div>
			</div>
			<div class="div_inputline">
				<div class="div_input">
					<input type="hidden" name="userid" value="<%= request.getParameter("userid") %>" />
					<input type="submit" value="Submit" class="input_button" tabindex=3 />
					<input type="reset" value="Clear" class="input_button" tabindex=4 />
				</div>
			</div>
		</form>
		<br />
	</div>

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
