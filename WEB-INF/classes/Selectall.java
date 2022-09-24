import java.io.IOException;
import java.io.PrintWriter;
import javax.servlet.*;
import javax.servlet.http.*;
import javax.servlet.ServletException;
import javax.servlet.annotation.WebInitParam;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.sql.*;
import java.util.*;

@WebServlet("/Selectall")
public class Selectall extends HttpServlet {

	public static String getUserRole(ResultSet rs) throws Exception {
		String role = "";
		while (rs.next()) {
			role = rs.getString(1);
		}
		return role;

	}

	public static void setSession(String username, HttpServletRequest request) {
		HttpSession session = request.getSession();
		session.setAttribute("username", username);
	}

	public void doGet(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {
		try {

			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
			ResultSet rs = DbHelper.GetResult(sql);

			ArrayList<String> al = new ArrayList<>();

			while (rs.next()) {
				String id = rs.getInt(1) + "";
				String name = rs.getString(2);
				String location = rs.getString(3);
				String nbed = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);

				al.add(id);
				al.add(name);
				al.add(location);
				al.add(nbed);
				al.add(obed);
				al.add(ibed);

			}
			req.setAttribute("data", al);

			String username = req.getParameter("username");

			setSession(username, req);

			String roleQuery = "select role from user where email='" + username + "'";
			ResultSet rs2 = DbHelper.GetResult(roleQuery);

			String userRole = getUserRole(rs2);

			if (userRole.length() < 1) {
				res.sendRedirect("http://localhost:8080/CBA/error.html");
			}

			if (userRole.equals("admin")) {
				req.getRequestDispatcher("admin.jsp").forward(req, res);
			} else if (userRole.equals("user")) {
				req.getRequestDispatcher("user.jsp").forward(req, res);
			}

		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void doPost(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException {

		try {

			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";

			ResultSet rs = DbHelper.GetResult(sql);

			ArrayList<String> al = new ArrayList<>();
			while (rs.next()) {
				String id = rs.getInt(1) + "";
				String name = rs.getString(2);
				String location = rs.getString(3);
				String nbed = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);
				al.add(id);
				al.add(name);
				al.add(location);
				al.add(nbed);
				al.add(obed);
				al.add(ibed);
			}

			req.setAttribute("data", al);

			String username = req.getParameter("username"); // Get username
			setSession(username, req); // Set Session for the user

			String roleQuery = "select role from user where email='" + username + "'";
			ResultSet rs2 = DbHelper.GetResult(roleQuery); // Gets the role of the user

			String userRole = getUserRole(rs2);

			if (userRole.length() < 1) {
				res.sendRedirect("http://localhost:8080/CBA/error.html");
			}

			if (userRole.equals("admin")) {
				req.getRequestDispatcher("admin.jsp").forward(req, res); // Forward to admin page
			} else if (userRole.equals("user")) {
				req.getRequestDispatcher("user.jsp").forward(req, res); // Forward to user page
			}
		} catch (SQLException e) {
			e.printStackTrace();
		} catch (Exception e) {
			e.printStackTrace();
		}

	}

}
