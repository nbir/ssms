<%@ page language="java" import="java.sql.*"%>
<%@ page errorPage="401.jsp" %>

<%
	if(request.getParameter("dispatchcode")!="" && request.getParameter("spacereq")!="" && request.getParameter("indate")!="")
	{
		try /*including driver clasd*/
		{
			Class.forName("com.ibm.db2.jcc.DB2Driver");
		}
		catch (ClassNotFoundException cnfe)
		{ }
		int spaceAvailable=0, spaceOccupied=0;
		try
		{	/*creating connection*/
			Connection con=null;
			%>	
				<%@ include file="include/dbcon.jspf" %>
			<%
			Statement stmt = con.createStatement();
			ResultSet rs = stmt.executeQuery("select spacereq from company where companyid="+Integer.parseInt(request.getParameter("companyid")));
			rs.next();
			
			spaceAvailable=Integer.parseInt(rs.getString(1));

			rs = stmt.executeQuery("select sum(spacereq) from store where companyid="+Integer.parseInt(request.getParameter("companyid"))+" and outdate is null");
			rs.next();

			String _spaceOccupied = rs.getString(1);
			if(_spaceOccupied != null)
				spaceOccupied= Integer.parseInt(_spaceOccupied);
			
			spaceAvailable=spaceAvailable-spaceOccupied;
			
			if(Integer.parseInt(request.getParameter("spacereq")) <= spaceAvailable)
			{/* make entry*/
				rs = stmt.executeQuery("select max(transid) from store");
				rs.next();
				
				int transId=1;
				String _transId = rs.getString(1);
				if(_transId != null)
					transId=1+Integer.parseInt(_transId);
				
				stmt.executeUpdate("insert into store(transid, companyid, dispatchcode, dispatchname, spacereq, indate) values("+transId+", "+Integer.parseInt(request.getParameter("companyid"))+", '"+request.getParameter("dispatchcode")+"', '"+request.getParameter("dispatchname")+"', "+Integer.parseInt(request.getParameter("spacereq"))+", '"+request.getParameter("indate")+"')");
			%>
				<jsp:forward page="/store.jsp">
					<jsp:param name="store" value="1"/>
					<jsp:param name="success" value="1"/>
					<jsp:param name="transid" value="<%= transId %>"/>
				</jsp:forward>
			<%	
			}
			else
			{
			%>
				<jsp:forward page="/store.jsp">
					<jsp:param name="store" value="1"/>
					<jsp:param name="invalid" value="4"/>
				</jsp:forward>
			<%	
			}
		}
		catch (SQLException sqle)
		{}
	}
	else
	{
	%>
		<jsp:forward page="/store.jsp">
			<jsp:param name="store" value="1"/>
			<jsp:param name="invalid" value="0"/>
		</jsp:forward>
	<%
	}
%>
