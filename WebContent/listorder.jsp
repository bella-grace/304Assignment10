<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Order List</title>
	<style> 
	body {
		background-color: #ffe6f3; 
		color: #5D5348; 
		font-family: Arial, sans-serif;
	}

	table {
		border: 1px solid #ff67ca; 
		border-collapse: collapse;
		width: 100%;
		margin-top: 20px;
	}

	th, td {
		border: 1px solid #ff67ca; 
		padding: 10px;
		text-align: left;
	}

	th {
		background-color: #ffc1f1;
		color: white;
	}

	h1 {
		color: #ff67ca; 
		font-size: 1.6em; 
	}

	h2 {
		color: #f991e1; 
		font-size: 1.6em; 
		text-align: center; 
	}

	h3 {
		color: #f991e1; 
		font-size: 1.2em; 
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
</head>
<body>

<%@ include file="header.jsp" %>

<h2>Order List</h2>

<%
//Note: Forces loading of SQL Server driver
try
{	// Load driver class
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
}
catch (java.lang.ClassNotFoundException e)
{
	out.println("ClassNotFoundException: " +e);
}

// Useful code for formatting currency values:
// NumberFormat currFormat = NumberFormat.getCurrencyInstance();
// out.println(currFormat.format(5.0));  // Prints $5.00

// Make connection

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
String uid = "sa";
String pw = "304#sa#pw";
			
try ( Connection con = DriverManager.getConnection(url, uid, pw);
	  Statement stmt = con.createStatement();)
{
		String SQL = "SELECT os.orderId, os.orderDate, c.customerId, c.firstName, os.TotalAmount, c.lastName FROM orderSummary AS os JOIN customer AS c ON os.customerId = c.customerId";
		String SQL2 = "SELECT productId, quantity, price FROM orderproduct WHERE orderId = ?";

		PreparedStatement pstmt = con.prepareStatement(SQL2);

		ResultSet rst = stmt.executeQuery(SQL);

		//Iterate through each order 
		while (rst.next()){ 

		String orderId = rst.getString(1);
		String orderDate = rst.getString(2); 
		String customerId = rst.getString(3); 
		String customerName = rst.getString(4) + " " + rst.getString(6); 
		String totalAmount = rst.getString(5); 

			out.println("<h3>Order ID: " + orderId + "</h3>");
			out.println("<table>"); 							
				out.print("<tr>"); 							
					out.println("<th>Order ID:</th>"); 		
					out.println("<th>Order Date:</th>"); 		
					out.println("<th>Customer ID:</th>"); 
					out.println("<th>Customer Name:</th>");
					out.println("<th>TotalAmount:</th>"); 		
				out.println("</tr>");	
				out.println("<tr>"); 
					out.println("<td>" + orderId + "</td>");
					out.println("<td>" + orderDate + "</td>");
					out.println("<td>" + customerId + "</td>");
					out.println("<td>" + customerName + "</td>");
					out.println("<td> $" + totalAmount + "</td>"); 
				out.println("</tr>");
			out.println("</table>");

		//retrieve product info, aka "inner" data 
		pstmt.setString(1, orderId);
		ResultSet rst2 = pstmt.executeQuery(); 

		out.println("<h3>Ordered Products:</h3>");	
				out.println("<table>"); 							//Starts table creation 
					out.println("<tr>"); 							//Starts the first table row (tr = Table row)
						out.println("<th>Product ID:</th>"); 		//Column Name (th = header, used for column names), typically td is used (td = table data)
						out.println("<th>Quantity:</th>"); 		
						out.println("<th>Price:</th>"); 
					out.println("</tr>");							//Signals end of table row 

		while (rst2.next()){ 
			String productId = rst2.getString(1); 
			String quantity = rst2.getString(2);
			String price = rst2.getString(3); 
					out.println("<tr>"); 								//Starts second table row 
						out.println("<td>" + productId + "</td>");	//Gets data for each column 
						out.println("<td>" + quantity + "</td>");
						out.println("<td> $" + price + "</td>");
						out.println("</tr>");
					//out.println("Product ID: " + rst2.getString(1) + "     " + "Quantity: " + rst2.getString(2) + "     " + "Price: " + rst2.getString(3));
					}
		out.println("</table>");	
				}

} catch (Exception e) {
    out.println("Exception: " + e);
}

%>

</body>
</html>

