<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Morganne and Bella's Grocery</title>
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
	input[type=text] {
        width: 25%;
        padding: 10px 17px;
        margin: 8px 0;
        box-sizing: border-box;
    }

	input[type=submit] {
        background-color: #f991e1;
  		border: none;
		color: white;
		padding: 10px 25px;
		border-radius: 8px;
		margin: 2px 2px;
    }

	input[type=reset] {
        background-color: #f991e1;
  		border: none;
		color: white;
		padding: 10px 25px;
		border-radius: 8px;
		margin: 2px 2px;
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

	a {
		text-decoration: none;
		color: #5D5348;
	}

	</style>
</head>
<body>

<%@ include file="header.jsp" %>


<h2> Search for the products you want to buy: </h2>

<form method="get" action="listprod.jsp">
<input type="text" name="productName" size="50">
<input type="submit" value="Submit"><input type="reset" value="Reset"> (Leave blank for all products)
</form>

<% 
String name = request.getParameter("productName"); // Get product name to search for
		
//Note: Forces loading of SQL Server driver
if(name != null) {
	try {	// Load driver class
		Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
		String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
		String uid = "sa";
		String pw = "304#sa#pw"; 

		Connection con = null;														//Create variables for connection
		PreparedStatement pstmt = null;
		ResultSet rst = null;

		try {
			con = DriverManager.getConnection(url, uid, pw);						// Make the connection
			String SQL = "SELECT * FROM Product WHERE productName LIKE ?";
			pstmt = con.prepareStatement(SQL);
			pstmt.setString(1, "%" + name + "%");
			rst = pstmt.executeQuery();
		
			if(!rst.isBeforeFirst()) { //if the cursor is not at the default position (top of the table), then print no products with given name
				out.println("<h2> No products found containing " + name + "</h2>");
			} else {
				if(name == "") {													//Header for no input(all products)
					out.println("<h2> Showing All Products </h2>");
				} else {															//Header if search is used
					out.println("<h2> Showing Products containing '" + name + "'</h2>");
				}
				out.println("<table>");												//start table
					out.println("<tr>");											//start new row for headers
						out.println("<th> Add to Cart </th>");
						out.println("<th> Product Name - Click to Learn More! </th> ");
						out.println("<th> Price </th>");
					out.println("</tr>");											//end row

					
					while(rst.next()) {												//iterate through SQL output to print matching products
						int id = rst.getInt("productId");
						String pname = rst.getString("productName");
						double pprice = rst.getDouble("productPrice");
						
						out.println("<tr>");										//new row, print add to cart link, product name, and price
						out.println("<td><a href='addcart.jsp?id=" + id + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + pprice + "'>Add to Cart</a></td>");
						out.println("<td><a href='product.jsp?id=" + id + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + pprice + "'>" + pname + "</a></td>");
						out.println("<td>" + NumberFormat.getCurrencyInstance().format(pprice) + "</td>");
                		out.println("</tr>");										//end row
					}
				}
					
				out.println("</table>");											//end the table
					
					} catch (SQLException ex) {
						out.println("SQLException: " + ex.getMessage());
					} finally {
						try {														//Close all connections
							if (rst != null)
								rst.close();
							if (pstmt != null)
								pstmt.close();
							if (con != null)
								con.close();
						} catch (SQLException ex) {
							out.println("SQLException in finally: " + ex.getMessage());
						}
					}	
	}
	catch (java.lang.ClassNotFoundException e)
	{
		out.println("ClassNotFoundException: " +e);
	}
}
%>
</body>
</html>