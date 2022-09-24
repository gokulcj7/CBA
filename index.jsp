<html>
	<head>
	</head>
	
<body>

	<%@ page import="java.sql.*"%>
	<%@page import="javax.servlet.http.*"%>;
	<%
		String username = request.getRemoteUser();
		session.setAttribute("email",username);
		request.getRequestDispatcher("/Selectall").include(request,response);
	%>
	



</body>