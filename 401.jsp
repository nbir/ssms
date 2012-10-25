<%@ page language="java" %>
<%@ page isErrorPage="true" %>

<%@ include file="include/pageHead" %>
<link rel="stylesheet" href="css/error.css">

<%@ include file="include/bodyHead" %>

<div id="div_link">
		<form action="index.jsp" method="post">
			<input type="submit" class="input_button" value="Home" />
		</form>
	</div>
	<!--
	<div class="div_notification">
		<p class="p_error">Notification.</p>
	</div>
	-->
	
	<div id="div_bodyleft">
		<p class="p_message">An unexpected error has occured. We regret the inconvenience.</p>
	</div>

<%@ include file="include/pageFoot" %>
