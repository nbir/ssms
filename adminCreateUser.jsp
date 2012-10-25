<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
	if(request.getParameter("username")!="" && request.getParameter("password")!="")
	{
		try
		{	/*creating connection*/
			Connection con=null;
			%>	
				<%@ include file="include/dbcon.jspf" %>
			<%
			Statement stmt = con.createStatement();
			
			ResultSet rs = stmt.executeQuery("select max(userid) from login");
			rs.next();
			int newUserId=1+Integer.parseInt(rs.getString(1));
			
			stmt.executeUpdate("insert into login values("+newUserId+", "+Integer.parseInt(request.getParameter("usertype"))+", '"+request.getParameter("username")+"', '"+request.getParameter("password")+"')");
		
			%>
				<jsp:forward page="/admin.jsp">
					<jsp:param name="success" value="2"/>
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

