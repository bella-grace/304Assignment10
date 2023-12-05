<!DOCTYPE html>
<html>
<head>
<title>Administrator Page</title>
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

	h2 {
		color: #ff67ca; 
		font-size: 1.1em; 
	}
</style>
</head>
<body>

<%@ include file="header.jsp" %>
<%@ include file="jdbc.jsp" %>
<%@ include file="auth.jsp" %>

<%

String url = "jdbc:sqlserver://cosc304_sqlserver:1433;DatabaseName=orders;TrustServerCertificate=True";	// Make connection	
String uid = "sa";
String pw = "304#sa#pw";

Connection con = null;						
PreparedStatement pstmt = null;
ResultSet rst = null;

try {
    con = DriverManager.getConnection(url, uid, pw);
	Statement stmt = con.createStatement();

    // TODO: Write SQL query that prints out total order amount by day
    String sql = "SELECT CONVERT(VARCHAR, orderDate, 23) AS formatDate, " +
    "SUM(totalAmount) AS total " +
    "FROM ordersummary " +
    "GROUP BY CONVERT(VARCHAR, orderDate, 23)";
    pstmt = con.prepareStatement(sql);
    rst = pstmt.executeQuery();

    out.println("<h2> Adminstrator Sales Report by Day </h2>");
    out.println("<table>"); 							
        out.print("<tr>"); 							
            out.println("<th>Order Date:</th>"); 		
            out.println("<th>Total Order Amount:</th>"); 		
        out.println("</tr>");

    while(rst.next()) {	
        String orderDate = rst.getString("formatDate");
        double total = rst.getDouble("total");

        out.println("<tr>"); 
            out.println("<td>" + orderDate + "</td>");
            out.println("<td> $" + total + "</td>"); 
        out.println("</tr>");
    }

    out.println("</table>");

} catch (SQLException ex) {
    out.println(ex);
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


%>

</body>
</html>

