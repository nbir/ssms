<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
	try
	{	/*creating connection*/
		Connection con=null;
		%>	
			<%@ include file="include/dbcon.jspf" %>
		<%
		Statement stmt = con.createStatement();
		stmt.executeUpdate("delete from login where username='"+request.getParameter("username")+"'");
	
		%>
			<jsp:forward page="/admin.jsp">
				<jsp:param name="success" value="3"/>
				<jsp:param name="admin" value="1"/>
			</jsp:forward>
		<%
	}
	catch (SQLException sqle)
	{}
%>
