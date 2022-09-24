import java.io.IOException;
import java.io.PrintWriter;
import java.io.*;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.sql.ResultSet;
import java.sql.*;
import java.util.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;

import java.security.*;
import java.math.*;
import java.text.SimpleDateFormat;
import java.util.Date;

public class Map extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {

			Connection con = null;

			PreparedStatement st = null;
			con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");

			SimpleDateFormat date = new SimpleDateFormat("yyyy.MM.dd.HH:mm:ss");
			String timeStamp = date.format(new Date());
			timeStamp = timeStamp + "Ur@#$1123";
			// System.out.println(timeStamp);

			MessageDigest m = MessageDigest.getInstance("SHA-256");
			m.update(timeStamp.getBytes(), 0, timeStamp.length());
			String hash = new BigInteger(1, m.digest()).toString(16);
			String url = "http://localhost:8080/CBA/report/" + hash;
			// System.out.println(url);

			String name = request.getParameter("name");
			String location = request.getParameter("location");
			String nbed = request.getParameter("nbed");
			String obed = request.getParameter("obed");
			String ibed = request.getParameter("ibed");

			String cond1 = request.getParameter("bed1");
			String cond2 = request.getParameter("bed2");
			String cond3 = request.getParameter("bed3");

			// System.out.println(name + " " + location + " " + nbed + " " + obed + " " +
			// ibed);

			// System.out.println(hash + " ");

			String query = "";
			query = "insert into url2(hash,name,location,nbed,obed,ibed,cond1,cond2,cond3) values(?,?,?,?,?,?,?,?,?)";
			st = con.prepareStatement(query);
			st.setString(1, hash);
			if (name.equals("") && location.equals("")) {
				st.setString(2, "null");
				st.setString(3, "null");
				st.setInt(4, 0);
				st.setInt(5, 0);
				st.setInt(6, 0);
				st.setString(7, "null");
				st.setString(8, "null");
				st.setString(9, "null");
			} else {
				st.setString(2, name);
				st.setString(3, location);
				st.setInt(4, Integer.parseInt(nbed));
				st.setInt(5, Integer.parseInt(obed));
				st.setInt(6, Integer.parseInt(ibed));
				st.setString(7, cond1);
				st.setString(8, cond2);
				st.setString(9, cond3);

			}

			int n = st.executeUpdate();

			response.getWriter().write(url);

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}