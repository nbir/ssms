<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
	if(request.getParameter("password")!="")
	{
		try
		{	/*creating connection*/
			Connection con=null;
			%>	
				<%@ include file="include/dbcon.jspf" %>
			<%
			Statement stmt = con.createStatement();
			stmt.executeUpdate("update login set password='"+request.getParameter("password")+"' where username='"+request.getParameter("username")+"'");
		
			%>
				<jsp:forward page="/admin.jsp">
					<jsp:param name="success" value="1"/>
					<jsp:param name="admin" value="1"/>
				</jsp:forward>
			<%
		}
		catch (SQLException sqle)
		{}
	}
	else
	{
	%>
		<jsp:forward page="/admin.jsp">
			<jsp:param name="invalid" value="0"/>
			<jsp:param name="admin" value="1"/>
		</jsp:forward>
	<%
	}
%>
