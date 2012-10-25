<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
	if(request.getParameter("companyname")!="" && request.getParameter("username")!=""&& request.getParameter("password")!="" && request.getParameter("email")!="" && request.getParameter("spacereq")!="")
	{/*password not null*/
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
			ResultSet rs = stmt.executeQuery("select count(*) from login where username='"+request.getParameter("username")+"'");
			rs.next();
			
			if(Integer.parseInt(rs.getString(1))==0)
			{
				try
				{/*is numeric*/
					int spaceReq=Integer.parseInt(request.getParameter("spacereq"));
					if(spaceReq <= Integer.parseInt(request.getParameter("availSpace")))
					{/*create user*/
						rs = stmt.executeQuery("select max(userid) from login");
						rs.next();
						int newUserId=Integer.parseInt(rs.getString(1))+1;
					
						stmt.executeUpdate("insert into login values("+newUserId+",4,'"+request.getParameter("username")+"','"+request.getParameter("password")+"')");
						stmt.executeUpdate("insert into company values("+newUserId+",'"+request.getParameter("companyname")+"','"+request.getParameter("email")+"',"+Integer.parseInt(request.getParameter("spacereq"))+")");
					
						%>
							<jsp:forward page="/index.jsp">
								<jsp:param name="success" value="1"/>
							</jsp:forward>
						<%	
					}
					else /*invalid space required*/
					{
					%>
						<jsp:forward page="/companyRegister.jsp">
							<jsp:param name="invalid" value="5"/>
						</jsp:forward>
					<%	
					}
				}
				catch(Exception e)
				{/*not numeric*/
				%>
					<jsp:forward page="/companyRegister.jsp">
						<jsp:param name="invalid" value="5"/>
					</jsp:forward>
				<%	
				}
			}
			else  /*username is used*/
			{
			%>
				<jsp:forward page="/companyRegister.jsp">
					<jsp:param name="invalid" value="2"/>
				</jsp:forward>
			<%
			}
			
			rs.close();
			stmt.close();
			con.close();
		}
		catch (SQLException sqle)
		{}
	}
	else
	{
	%>
		<jsp:forward page="/companyRegister.jsp">
			<jsp:param name="invalid" value="1"/>
		</jsp:forward>
	<%
	}
%>
