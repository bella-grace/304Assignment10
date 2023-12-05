<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.util.Date" %>
<%@ include file="jdbc.jsp" %>

<html>
<head>
<title>Morganne and Bella's Grocery Shipment Processing</title>
<style>
	body {
		background-color: #ffe6f3; 
		color: #5D5348; 
		font-family: Arial, sans-serif;
	}

	h3 {
		color: #ff67ca; 
		font-size: 1.1em; 
	}
</style>
</head>
<body>
        
<%@ include file="header.jsp" %>

<%
	// TODO: Get order id ??
	String orderId = request.getParameter("orderId"); 	
	//String orderId = "1"; 


	// TODO: Check if valid order id in database
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";		
	String uid = "sa";
	String pw = "304#sa#pw";

	try ( Connection con = DriverManager.getConnection(url, uid, pw);
	  Statement stmt = con.createStatement();)
	{
		// TODO: Start a transaction (turn-off auto-commit)
		//con.setAutocommit(false); 																	// Forces explicit commit/rollback 

		String SQL = "SELECT * FROM orderSummary WHERE orderId = ?"; 								//Validates order Id to database 
		String SQL2 = "SELECT productId, quantity FROM orderproduct WHERE orderId = ?";				//Returns product information from each order
		String SQL3 = "SELECT productId, quantity, warehouseId FROM productInventory WHERE productId = ?"; 

		PreparedStatement pstmt = con.prepareStatement(SQL);
		pstmt.setString(1, orderId);

		ResultSet rst = pstmt.executeQuery(); 
		boolean sufficientQty = true; 

		if(rst.next()){ 


			pstmt = con.prepareStatement(SQL2);
			pstmt.setString(1, orderId);

			ResultSet rst2 = pstmt.executeQuery(); 

			// TODO: Retrieve all items in order with given id AND 
			// TODO: For each item verify sufficient quantity available in warehouse 1.
	
			while (rst2.next()){ 												//Retrieves each product's Id and quantity requested 
				String productId = rst2.getString("productId"); 
				String quantity = rst2.getString("quantity");

				pstmt = con.prepareStatement(SQL3);
				pstmt.setString(1, productId);

				ResultSet rst3 = pstmt.executeQuery(); 

				while(rst3.next()){												//Confirms each product quantity requested is available at main warehouse (1) 
					String pinventory = rst3.getString("quantity"); 
					int intQuantity = Integer.parseInt(quantity);
					int intPInventory = Integer.parseInt(pinventory);

					if(intPInventory > intQuantity || intPInventory == intQuantity){		
						out.println("<h3>Ordered Product: " + productId + "</h3>"); 
						out.println("<h3>Qty: " + intQuantity + "</h3>"); 
						out.println("<h3>Previous Inventory: " + intPInventory + "</h3>"); 
						out.println("<h3>New Inventory: " + (intPInventory - intQuantity) + "</h3>"); 
						intPInventory = (intPInventory - intQuantity);
						pinventory = String.valueOf(intPInventory);
						pstmt = con.prepareStatement("UPDATE productInventory SET quantity = ? WHERE productId = ?");
						pstmt.setString(1, pinventory);
						pstmt.setString(2, productId);
						pstmt.executeUpdate(); 
						con.commit(); 
						continue; 
					}
					else{
						out.println("<h3>Shipment incomeplete: Insuffient stock</h3>");
						con.rollback(); 
					}
				}
					// TODO: Create a new shipment record.
					// Update inventory (Shipment & Product inventory relations?)
			}
		}
		else { 
			//
		}

	} catch (Exception e) {
    out.println("Exception: " + e);
	}
	
	//con.setAutocommit(true); 												//Enables inexplicit commit/rollback
	// TODO: Auto-commit should be turned back on
%>                       				

<h2><a href="shop.html">Back to Main Page</a></h2>

</body>
</html>
