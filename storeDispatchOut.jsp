<%@ page language="java" import="java.sql.*"%>
<%@ page import="java.util.*" %>
<%@ page import="java.util.Date"%>
<%@ page import="javax.mail.*" %>
<%@ page import="javax.mail.internet.*" %>
<%@ page import="javax.activation.*" %>

<%@ page errorPage="401.jsp" %>

<%
	if(request.getParameter("transid")!="" && request.getParameter("outdate")!="")
	{
		int transid=0;
		try
		{
			transid=Integer.parseInt(request.getParameter("transid"));
		}
		catch(Exception scnve)
		{
			%>
				<jsp:forward page="/store.jsp">
					<jsp:param name="store" value="1"/>
					<jsp:param name="invalid" value="9"/>
				</jsp:forward>
			<%
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
			ResultSet rs = stmt.executeQuery("select count(*) from store where companyid="+Integer.parseInt(request.getParameter("companyid"))+" and transid="+transid+" and outdate is null");
			rs.next();
						
			if(Integer.parseInt(rs.getString(1))!=0)
			{/* make entry*/
				stmt.executeUpdate("update store set outdate='"+request.getParameter("outdate")+"' where transid="+transid);
				
				rs = stmt.executeQuery("select email, companyname, spacereq from company where companyid="+Integer.parseInt(request.getParameter("companyid")));
				rs.next();
				
				int spaceAvailable=0, spaceOccupied=0;
				String email=rs.getString(1);
				String companyname=rs.getString(2);
				spaceAvailable=Integer.parseInt(rs.getString(3));
				
				rs = stmt.executeQuery("select sum(spacereq) from store where companyid="+Integer.parseInt(request.getParameter("companyid"))+" and outdate is null");
				rs.next();

				String _spaceOccupied = rs.getString(1);
				if(_spaceOccupied != null)
					spaceOccupied= Integer.parseInt(_spaceOccupied);
			
				spaceAvailable=spaceAvailable-spaceOccupied;
				
				rs = stmt.executeQuery("select dispatchcode from store where transid="+transid);
				rs.next();
				String dispatchcode = rs.getString(1);
				
				try {
				/*SEND MAIL*/
				String host="", user="", pass="";
				%>	
					<%@ include file="include/hostEmail.jspf" %>
				<%
				
				String messageText = "<p>Dear "+companyname+"<p>Your last shipment that went out was "+dispatchcode+" on "+request.getParameter("outdate")+", and your available free space is "+spaceAvailable+" square meters.<p>We Appreciate your business.<p>Thank you<p>ABC Corp.";
				
				boolean sessionDebug = false	;
				Properties props = System.getProperties();
				props.put("mail.host", host);
				props.put("mail.transport.protocol", "smtp");
				
				String SSL_FACTORY ="javax.net.ssl.SSLSocketFactory";
				props.put("mail.smtp.auth", "true");
				props.put("mail.smtp.", "true");
				props.put("mail.smtp.port", "465");
				props.put("mail.smtp.socketFactory.fallback", "false");
				props.put("mail.smtp.socketFactory.class", SSL_FACTORY);

				Session mailSession = Session.getDefaultInstance(props, null);
				mailSession.setDebug(sessionDebug);

				Message msg = new MimeMessage(mailSession);
				InternetAddress[] address = {new InternetAddress(email)};
				msg.setRecipients(Message.RecipientType.TO, address);
				msg.setSubject("SSMS Notification (ABC Corp.)");
				msg.setSentDate(new Date());
				msg.setContent(messageText,"text/html");

				Transport transport = mailSession.getTransport("smtp");
				transport.connect(host, user, pass);
				transport.sendMessage(msg, msg.getAllRecipients());
				/*Mail sending end*/
				} catch(Exception maile) {}
				
			%>
				<jsp:forward page="/store.jsp">
					<jsp:param name="store" value="1"/>
					<jsp:param name="success" value="2"/>
				</jsp:forward>
			<%	
			}
			else
			{
			%>
				<jsp:forward page="/store.jsp">
					<jsp:param name="store" value="1"/>
					<jsp:param name="invalid" value="7"/>
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
