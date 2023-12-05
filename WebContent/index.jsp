<!DOCTYPE html>
<html>
<head>
        <title>Morganne and Bella's Grocery Main Page</title>
</head>

<style> 
	body {
			background-color: #ffe6f3; 
			color: #5D5348; 
			font-family: Arial, sans-serif;
	}

	h1 {
			color: #f991e1; 
			font-size: 1.8em; 
			text-align: center; 
	}

	h2 {
			color: #f991e1; 
			font-size: 1.5em; 
			text-align: center; 
	}

	ul {
			list-style-type: none;
			margin: 0;
			padding: 0;
			overflow: hidden;
			background-color: #f991e1;
	}
	
	li {
			float: left;
	}
	
	li a {
			display: block;
			color: white;
			text-align: center;
			padding: 14px 16px;
			text-decoration: none;
	}
	
	li a:hover {
			background-color: #d463ba;
	}

	</style>

<body>
<h1 align="center">Welcome to Morganne and Bella's Grocery</h1>

<h2 align="center"><a href="login.jsp">Login</a></h2>

<h2 align="center"><a href="listprod.jsp">Begin Shopping</a></h2>

<h2 align="center"><a href="listorder.jsp">List All Orders</a></h2>

<h2 align="center"><a href="customer.jsp">Customer Info</a></h2>

<h2 align="center"><a href="admin.jsp">Administrators</a></h2>

<h2 align="center"><a href="logout.jsp">Log out</a></h2>

<%
	String userName = (String) session.getAttribute("authenticatedUser");
	if (userName != null)
		out.println("<h3 align=\"center\">Signed in as: "+userName+"</h3>");
%>

<h4 align="center"><a href="ship.jsp?orderId=1">Test Ship orderId=1</a></h4>

<h4 align="center"><a href="ship.jsp?orderId=3">Test Ship orderId=3</a></h4>

</body>
</head>


