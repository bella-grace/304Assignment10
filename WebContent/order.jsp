<%@ page import="java.sql.*" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.util.Iterator" %>
<%@ page import="java.util.ArrayList" %>
<%@ page import="java.util.Map" %>
<%@ page import="java.text.SimpleDateFormat" %>
<%@ page import="java.util.Date" %>

<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>
<!DOCTYPE html>
<html>
<head>
<title>Morganne and Bella's Grocery Order Processing</title>
<style> 
	body {
		background-color: #ffe6f3; 
		color: #5D5348; 
		font-size: 1.2em; 
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
		color: #fff1e2; 
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

	
	</style>
</head>
<body>

<% 
String custId = request.getParameter("customerId");														//Get customer id input
String custPass = request.getParameter("customerPassword");												//Get customer password input
double pr = 0;																							//Initalize item price, quantity, and totalCartamount
int qty = 1;
double cartTotal = 0;																					//Initalize cart total amount
String productString = "";																				//String to store 

@SuppressWarnings({"unchecked"})
HashMap<String, ArrayList<Object>> productList = (HashMap<String, ArrayList<Object>>) session.getAttribute("productList");

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";	// Make connection	
String uid = "sa";
String pw = "304#sa#pw";

Connection con = null;																					//Create variables for connection
PreparedStatement pstmt = null;
ResultSet rst = null;


try {
	con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();

	if (productList.isEmpty()) {																		//if cart is empty
		throw new NullPointerException();
	}
	if(custId == null) {																				//if customerId was not entered
		throw new IndexOutOfBoundsException();
	}

																										//Retrieve customer id and password inputs
	String custInfo = "SELECT customerId, password FROM customer WHERE customerId = ?";
	PreparedStatement pstmt1 = con.prepareStatement(custInfo);
	pstmt1.setString(1, custId);
	ResultSet rst1 = pstmt1.executeQuery();

	if(!rst1.next()) {																					//Validate Customer ID input
		throw new IndexOutOfBoundsException();
	}

	String pass = rst1.getString("password");															//Validate Password input
	if(!pass.equals(custPass)) {
		throw new IllegalArgumentException();
	}
	rst1.close();

	//Retrieve customerId
	String cidSQL = "SELECT TOP 1 orderId FROM ordersummary ORDER BY orderId DESC";						//SQL query to retrieve customerId
	String retrieveIdSQL = "SELECT customerId, firstName, lastName FROM customer WHERE customerId = ?"; //SQL query with info to save
	ResultSet cidrst = stmt.executeQuery(cidSQL);														//execute SQL query to get customerId
	PreparedStatement pstmt2 = con.prepareStatement(retrieveIdSQL);
	pstmt2.setInt(1, Integer.parseInt(custId));
	ResultSet rst2 = pstmt2.executeQuery();

	NumberFormat numFormat = NumberFormat.getCurrencyInstance();										//Print out orderSummary header and format price for each item
	while(rst2.next()) {
		out.println("<h2> Your Order Summary: </h2>");
		numFormat = NumberFormat.getCurrencyInstance();
	}

	SimpleDateFormat dateForm = new SimpleDateFormat("yyyy-MM-dd HH:mm:ss");							//get date for orderDate
	Date date = new Date();
	String formattedDate = dateForm.format(date);
	String addToOrderSQL = "INSERT INTO ordersummary (customerId, orderDate, totalAmount) VALUES (?, ?, " + 0 + ")";

	PreparedStatement pstmt3 = con.prepareStatement(addToOrderSQL, Statement.RETURN_GENERATED_KEYS);	//Use retrieval of auto-generated keys
	pstmt3.setString(1, custId);
	pstmt3.setString(2, formattedDate);
	pstmt3.executeUpdate();
	ResultSet keys = pstmt3.getGeneratedKeys();
	keys.next();
	int ordId = keys.getInt(1);
	keys.close();

	out.print("<table>");																				//Start table to print out customer Order Summary
		out.print("<tr>");
		out.print("<th> Product Id </th> <th> Product Name </th> <th> Quantity </th>");					//Order Summary table headers
	out.println("<th> Price </th><th> Subtotal </th> </tr>");
																										//SQL to add into OrderProduct, using orderId from last query
	String addToOrderProduct = "INSERT INTO orderproduct (orderId, productId, quantity, price) VALUES (" + ordId + ", ?, ?, ?)";
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext()) { 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		if (product.size() < 4)																			//Code from showcart.jsp to display order after checking out
		{
			out.println("Expected product with four entries. Got: "+product);
			continue;
		}
		url = "addcart.jsp?removeId=" + product.get(0);
		out.print("<tr><td>"+product.get(0)+"</td>");
		out.print("<td>"+product.get(1)+"</td>");
		out.print("<td align=\"center\">"+product.get(3)+"</td>");
		Object price = product.get(2);			//get quantity
		Object itemQTY = product.get(3);		//get price
		productString = product.get(0) + ""; 	//get id
		pr = 0;
		qty = 0;
		
		try {
			pr = Double.parseDouble(price.toString());
		} catch (Exception e) {
			out.println("Invalid price for product: "+product.get(0)+" price: "+price);
		}
		try {
			qty = Integer.parseInt(itemQTY.toString());
		} catch (Exception e) {
			out.println("Invalid quantity for product: "+product.get(0)+" quantity: "+qty);
		}		

		out.print("<td align=\"right\">"+numFormat.format(pr)+"</td>");
		out.print("<td align=\"right\">"+numFormat.format(pr*qty)+"</td></tr>");
		out.println("</tr>");																			//End code from showcart.jsp
		
		//Calculate new cartTotal
		cartTotal = cartTotal + pr * qty;

		PreparedStatement pstmt4 = con.prepareStatement(addToOrderProduct);								//SQL to add to orderproduct
		pstmt4.setString(1, productString);
		pstmt4.setInt(2, qty);
		pstmt4.setDouble(3, pr);
		pstmt4.executeUpdate();
	}

	String updateTotalAmt = "UPDATE ordersummary SET totalAmount = ? WHERE orderId = ?";				//Update ordersummary with new Order
	PreparedStatement pstmt5 = con.prepareStatement(updateTotalAmt);
	pstmt5.setDouble(1, cartTotal);
	pstmt5.setInt(2, ordId);
	pstmt5.executeUpdate();
	out.println("<tr><td colspan=\"4\" align=\"right\"><b>Order Total</b></td>"+"<td align=\"right\">"+numFormat.format(cartTotal)+"</td></tr>");
	out.print("</table>");																				//close ordersummary table
	out.print("<h2> Order Completed! </h2>");
	session.setAttribute("productList", null);															//clear cart
	out.println("<h2><a href='shop.html'>Back to Main Page</a></h2>");									//Option to go back to main page


} catch (SQLException ex) {																				//Use characters in customerID
	out.println("Please enter a valid Customer Id");
} catch (NullPointerException ex) {																		//Empty Cart exception
	out.println("Your shopping cart is empty. Please add products and try again.");
	out.println("<h2><a href='listprod.jsp'>Continue Shopping</a></h2>");	
} catch (IndexOutOfBoundsException ex) {																//Invalid ID exception
	out.println("Please enter a valid Customer ID");
} catch (IllegalArgumentException ex) {																	//Invalid Password exception
	out.println("Invalid Password. Please go back and try again.");
} finally {
	try {																								//Close all connections
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


// Save order information to database
	/*
	// Use retrieval of auto-generated keys.
	PreparedStatement pstmt = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);			
	ResultSet keys = pstmt.getGeneratedKeys();
	keys.next();
	int orderId = keys.getInt(1);
	*/
// Insert each item into OrderProduct table using OrderId from previous INSERT
// Update total amount for order record
// Here is the code to traverse through a HashMap
// Each entry in the HashMap is an ArrayList with item 0-id, 1-name, 2-quantity, 3-price
/*
	Iterator<Map.Entry<String, ArrayList<Object>>> iterator = productList.entrySet().iterator();
	while (iterator.hasNext())
	{ 
		Map.Entry<String, ArrayList<Object>> entry = iterator.next();
		ArrayList<Object> product = (ArrayList<Object>) entry.getValue();
		String productId = (String) product.get(0);
        String price = (String) product.get(2);
		double pr = Double.parseDouble(price);
		int qty = ( (Integer)product.get(3)).intValue();
            ...
	}
*/
// Print out order summary
// Clear cart if order placed successfully
%>
</BODY>
</HTML>

