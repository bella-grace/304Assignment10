<%@ page import="java.sql.*,java.net.URLEncoder" %>
<%@ page import="java.util.HashMap" %>
<%@ page import="java.text.NumberFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF8"%>

<%@ include file="jdbc.jsp" %>

<html>
<head>
<title> Product Information </title>
<link href="css/bootstrap.min.css" rel="stylesheet">
<style>
	a {
		text-decoration: none;
		color: #ff67ca;
		text-align: center
	}

	img {
		Padding: 10px,10px,10px,10px; 
	}
</style>
</head>
<body>

<%@ include file="header.jsp" %>

<%
// Get product name to search for
// TODO: Retrieve and display info for the product

String productId = request.getParameter("id");
try {
	Class.forName("com.microsoft.sqlserver.jdbc.SQLServerDriver");
	String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";
	String uid = "sa";
	String pw = "304#sa#pw"; 

	Connection con = null;														//Create variables for connection
	PreparedStatement pstmt = null;
	ResultSet rst = null;

	try {
		con = DriverManager.getConnection(url, uid, pw);
		String sql = "SELECT productName, productId, productDesc, productPrice, productImageURL, productImage FROM product WHERE productId = ?";
		pstmt = con.prepareStatement(sql);
		pstmt.setString(1, productId);
		rst = pstmt.executeQuery();

		while(rst.next()) {										
			int id = rst.getInt("productId");
			String pname = rst.getString("productName");
			double pprice = rst.getDouble("productPrice");
			String pURL = rst.getString("productImageURL");
			String pDesc = rst.getString("productDesc");
			String pBin = rst.getString("productImage");

			out.println("<h1>&emsp;" + pname + "</h1>");

			//If there is a productImageURL, display using IMG tag
			if(pURL != null) {										
				out.println("<img src= " + pURL + " >");										
			}

			//  Retrieve any image stored directly in database. Note: Call displayImage.jsp with product id as parameter.
			if(pBin != null) {
				out.println("<img src= 'displayImage.jsp?id=" + id + "' ><br>");
			}
			out.println("<br><b>&emsp; Id:</b> " + id);

			out.println("<br><b>&emsp; Price:</b> " + NumberFormat.getCurrencyInstance().format(pprice) + "<br><br>");
			out.println("&emsp; " + pname + " includes " + pDesc);

			out.println("<h3><a href='addcart.jsp?id=" + id + "&name=" + URLEncoder.encode(pname, "UTF-8") + "&price=" + pprice + "'> Add to Cart </a></h3>");
			out.println("<h3><a href='listprod.jsp'> Continue Shopping </a></h3>");
		}
	

		} catch (SQLException ex) {
			out.println("Exception: " + ex);
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
} catch (NullPointerException ex) {
	out.println("Exception: " + ex);
}

		
		
// TODO: Add links to Add to Cart and Continue Shopping
%>

</body>
</html>
