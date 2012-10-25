<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
if(request.getParameter("fromdate")=="" || request.getParameter("todate")=="")
{
%>
	<jsp:forward page="/manager.jsp">
		<jsp:param name="manager" value="1"/>
		<jsp:param name="invalid" value="0"/>
	</jsp:forward>
<%
}
else
{
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

<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/managerReport.css">
<%@ include file="include/bodyHead" %>

	<div id="div_link">
		<form onSubmit="window.close();">
			<input type="submit" class="input_button" value="Close" />
		</form>
	</div>
	
	<%
		ResultSet rs = stmt.executeQuery("select companyname from company where companyid="+Integer.parseInt(request.getParameter("userid")));
		rs.next();
	%>
	<div class="div_notification">
		<p class="p_reportentry">Report for <%= rs.getString(1) %></p>
	</div>
	
	<p class="p_message">Dispatches in storage:</p>
	<div class="div_bodyright">
		<div class="div_heading">
			<table class="table_dispatch">
			<tr>
				<td class="tr_dispatch"><p class="p_heading">Dispatch Code</p></td>
				<td class="tr_dispatch"><p class="p_heading">Dispatch Name</p></td>
				<td class="tr_dispatch"><p class="p_heading">In date</p></td>
				<td class="tr_dispatch"></td>
			</tr>
			</table>
		</div>
		<br /><br />
		<table class="table_dispatch">
			<%
				rs = stmt.executeQuery("select dispatchcode, dispatchname, indate from store where companyid="+Integer.parseInt(request.getParameter("userid"))+" and outdate is null and indate >= '"+request.getParameter("fromdate")+"' and indate <= '"+request.getParameter("todate")+"'");
				
				while(rs.next())
				{			
			%>
			<tr>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(1) %></p></td>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(2) %></p></td>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(3) %></p></td>
				<td class="tr_dispatch"></td>
			</tr>
			<%
				}
			%>
		</table>
		<br />
	</div>
	
	<p class="p_message">Dispatches sent out:</p>
	<div class="div_bodyright">
		<div class="div_heading">
			<table class="table_dispatch">
			<tr>
				<td class="tr_dispatch"><p class="p_heading">Dispatch Code</p></td>
				<td class="tr_dispatch"><p class="p_heading">Dispatch Name</p></td>
				<td class="tr_dispatch"><p class="p_heading">In date</p></td>
				<td class="tr_dispatch"><p class="p_heading">Out date</p></td>
			</tr>
			</table>
		</div>
		<br /><br />
		<table class="table_dispatch">
			<%
				rs = stmt.executeQuery("select dispatchcode, dispatchname, indate, outdate from store where companyid="+Integer.parseInt(request.getParameter("userid"))+" and outdate is not null and indate >= '"+request.getParameter("fromdate")+"' and outdate <= '"+request.getParameter("todate")+"'");
				
				while(rs.next())
				{			
			%>
			<tr>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(1) %></p></td>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(2) %></p></td>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(3) %></p></td>
				<td class="tr_dispatch"><p class="p_reportentry"><%= rs.getString(4) %></p></td>
			</tr>
			<%
				}
			%>
		</table>
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
%>
