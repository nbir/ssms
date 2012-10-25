<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
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
		ResultSet rs = stmt.executeQuery("select userid, usertype from login where username='"+request.getParameter("username")+"' and password='"+request.getParameter("password")+"'");
			
		//response.getWriter().println();
		if(rs.next())
		{
			int userid=Integer.parseInt(rs.getString(1));
			switch(Integer.parseInt(rs.getString(2)))
			{
				/*add attribute and set forward url*/
				case 1:
					%>
					<jsp:forward page="/admin.jsp">
						<jsp:param name="admin" value="1"/>
						<jsp:param name="userid" value="<%= userid %>"/>
					</jsp:forward>
					<%
					break;
				case 2:
					%>
					<jsp:forward page="/manager.jsp">
						<jsp:param name="manager" value="1"/>
						<jsp:param name="userid" value="<%= userid %>"/>
					</jsp:forward>
					<%
					break;
				case 3:
					%>
					<jsp:forward page="/store.jsp">
						<jsp:param name="store" value="1"/>
						<jsp:param name="userid" value="<%= userid %>"/>
					</jsp:forward>
					<%
					break;
				case 4:
					%>
					<jsp:forward page="/company.jsp">
						<jsp:param name="company" value="1"/>
						<jsp:param name="userid" value="<%= userid %>"/>
					</jsp:forward>
					<%
					break;
			};
		}
		else
		{
			%>
				<jsp:forward page="/index.jsp">
					<jsp:param name="invalid" value="2"/>
				</jsp:forward>
			<%
		}
				
		rs.close();
		stmt.close();
		con.close();
	}
	catch (SQLException sqle)
	{ }
%>
