import java.io.IOException;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.DriverManager;
import java.sql.ResultSet;
import java.sql.*;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpServlet;
import javax.servlet.*;
import org.json.JSONObject;
import org.json.simple.JSONArray;

public class Ajax extends HttpServlet {
	public void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		ServletInputStream mServletInputStream = request.getInputStream();
		byte[] httpinData = new byte[request.getContentLength()];
		int retVal = -1;

		StringBuilder stringBuilder = new StringBuilder();

		while ((retVal = mServletInputStream.read(httpinData)) != -1) {
			for (int i = 0; i < retVal; i++) {
				stringBuilder.append(Character.toString((char) httpinData[i]));
			}
		}
		String texts = stringBuilder.toString();
		System.out.println(texts + " " + "hi");
		try {
			JSONObject ob = new JSONObject(texts);
			System.out.println();
			System.out.println(ob.getJSONArray("data"));
			JSONObject data = (JSONObject) ob.getJSONArray("data").get(0);
			String id = data.getJSONObject("attributes").getString("hid");
			String name = data.getJSONObject("attributes").getString("hospital_name");
			String location = data.getJSONObject("attributes").getString("location");
			String nbed = data.getJSONObject("attributes").getString("normal_beds");
			String obed = data.getJSONObject("attributes").getString("oxygen_beds");
			String ibed = data.getJSONObject("attributes").getString("icu_beds");
			System.out.println(id + " " + name + " " + location + " " + nbed + " " + obed + " " + ibed);

			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			String query1 = "insert into hospitals values(?,?,?)";
			String query2 = "insert into hospital_information values(?,?,?,?,?)";

			PreparedStatement st1 = con.prepareStatement(query1);
			PreparedStatement st2 = con.prepareStatement(query2);

			st1.setInt(1, Integer.parseInt(id));
			st1.setString(2, name);
			st1.setString(3, location);

			st2.setInt(1, Integer.parseInt(id));
			st2.setString(2, name);
			st2.setInt(3, Integer.parseInt(nbed));
			st2.setInt(4, Integer.parseInt(obed));
			st2.setInt(5, Integer.parseInt(ibed));

			int n1 = st1.executeUpdate();
			int n2 = st2.executeUpdate();

		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			Statement st = con.createStatement();
			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
			ResultSet rs = st.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray arr = new JSONArray();

			int i = 1;
			while (rs.next()) {
				JSONObject details = new JSONObject();
				details.put("type", "hospitals");
				details.put("id", i + "");
				JSONObject attributes = new JSONObject();
				i++;
				String rn = (rs.getInt(1) + "");
				String na = rs.getString(2);
				String pe = rs.getString(3);
				String ad = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);
				attributes.put("hid", rn);
				attributes.put("hospital_name", na);
				attributes.put("location", pe);
				attributes.put("normal_beds", ad);
				attributes.put("oxygen_beds", obed);
				attributes.put("icu_beds", ibed);
				details.put("attributes", attributes);
				arr.add(details);
			}
			json.put("data", arr);
			response.getWriter().write(json.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

	}

	public void doPut(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

		ServletInputStream mServletInputStream = request.getInputStream();
		byte[] httpinData = new byte[request.getContentLength()];
		int retVal = -1;

		StringBuilder stringBuilder = new StringBuilder();

		while ((retVal = mServletInputStream.read(httpinData)) != -1) {
			for (int i = 0; i < retVal; i++) {
				stringBuilder.append(Character.toString((char) httpinData[i]));
			}
		}
		String texts = stringBuilder.toString();
		try {
			JSONObject ob = new JSONObject(texts);
			System.out.println();
			System.out.println(ob.getJSONArray("data"));
			JSONObject data = (JSONObject) ob.getJSONArray("data").get(0);
			System.out.println(data);
			String id = data.getJSONObject("attributes").getString("hid");
			String name = data.getJSONObject("attributes").getString("hospital_name");
			String location = data.getJSONObject("attributes").getString("location");
			String nbed = data.getJSONObject("attributes").getString("normal_beds");
			String obed = data.getJSONObject("attributes").getString("oxygen_beds");
			String ibed = data.getJSONObject("attributes").getString("icu_beds");
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			String query1 = "update hospital_information set normal_bed =? where hospital_id=?";
			String query2 = "update hospital_information set oxygen_bed =? where hospital_id=?";
			String query3 = "update hospital_information set icu_bed =? where hospital_id=?";
			String query4 = "update hospital_information set Hospital_Name =? where hospital_id=?";

			PreparedStatement st1 = con.prepareStatement(query1);
			PreparedStatement st2 = con.prepareStatement(query2);
			PreparedStatement st3 = con.prepareStatement(query3);
			PreparedStatement st4 = con.prepareStatement(query4);

			st1.setInt(1, Integer.parseInt(nbed));
			st1.setInt(2, Integer.parseInt(id));

			st2.setInt(1, Integer.parseInt(obed));
			st2.setInt(2, Integer.parseInt(id));

			st3.setInt(1, Integer.parseInt(ibed));
			st3.setInt(2, Integer.parseInt(id));

			st4.setString(1, name);
			st4.setInt(2, Integer.parseInt(id));

			int n1 = st1.executeUpdate();
			int n2 = st2.executeUpdate();
			int n3 = st3.executeUpdate();
			int n4 = st4.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			Statement st = con.createStatement();
			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
			ResultSet rs = st.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray arr = new JSONArray();

			int i = 1;
			while (rs.next()) {
				JSONObject details = new JSONObject();
				details.put("type", "hospitals");
				details.put("id", i + "");
				JSONObject attributes = new JSONObject();
				i++;
				String rn = (rs.getInt(1) + "");
				String na = rs.getString(2);
				String pe = rs.getString(3);
				String ad = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);

				attributes.put("hid", rn);
				attributes.put("hospital_name", na);
				attributes.put("location", pe);
				attributes.put("normal_beds", ad);
				attributes.put("oxygen_beds", obed);
				attributes.put("icu_beds", ibed);
				details.put("attributes", attributes);
				arr.add(details);
			}
			json.put("data", arr);
			response.getWriter().write(json.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
		try {
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			Statement st = con.createStatement();
			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
			ResultSet rs = st.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray arr = new JSONArray();

			int i = 1;
			while (rs.next()) {
				JSONObject details = new JSONObject();
				details.put("type", "hospitals");
				details.put("id", i + "");
				JSONObject attributes = new JSONObject();
				i++;
				String rn = (rs.getInt(1) + "");
				String na = rs.getString(2);
				String pe = rs.getString(3);
				String ad = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);
				attributes.put("hid", rn);
				attributes.put("hospital_name", na);
				attributes.put("location", pe);
				attributes.put("normal_beds", ad);
				attributes.put("oxygen_beds", obed);
				attributes.put("icu_beds", ibed);
				details.put("attributes", attributes);
				arr.add(details);
			}
			json.put("data", arr);
			response.getWriter().write(json.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}
	}

	public void doDelete(HttpServletRequest request, HttpServletResponse response)
			throws ServletException, IOException {

		ServletInputStream mServletInputStream = request.getInputStream();
		byte[] httpinData = new byte[request.getContentLength()];
		int retVal = -1;

		StringBuilder stringBuilder = new StringBuilder();

		while ((retVal = mServletInputStream.read(httpinData)) != -1) {
			for (int i = 0; i < retVal; i++) {
				stringBuilder.append(Character.toString((char) httpinData[i]));
			}
		}
		String texts = stringBuilder.toString();

		try {
			JSONObject ob = new JSONObject(texts);
			JSONObject data = (JSONObject) ob.getJSONArray("data").get(0);
			String id = data.getJSONObject("attributes").getString("hid");
			String name = data.getJSONObject("attributes").getString("hospital_name");
			String location = data.getJSONObject("attributes").getString("location");
			String nbed = data.getJSONObject("attributes").getString("normal_beds");
			String obed = data.getJSONObject("attributes").getString("oxygen_beds");
			String ibed = data.getJSONObject("attributes").getString("icu_beds");
			System.out.println(id + " " + name + " " + location + " " + nbed + " " + obed + " " + ibed);
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");

			String sql1 = "delete from hospital_information where hospital_id=?";
			String sql = "delete from hospitals where hospital_id=?";

			PreparedStatement st1 = con.prepareStatement(sql1);
			PreparedStatement st = con.prepareStatement(sql);

			st1.setInt(1, Integer.parseInt(id));
			st.setInt(1, Integer.parseInt(id));

			st1.executeUpdate();
			st.executeUpdate();
		} catch (Exception e) {
			e.printStackTrace();
		}
		try {
			Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
			Statement st = con.createStatement();
			String sql = "select hospitals.hospital_id,hospital_information.Hospital_Name,hospitals.location,hospital_information.normal_bed,hospital_information.oxygen_bed,hospital_information.icu_bed FROM hospitals INNER JOIN hospital_information ON hospitals.hospital_id=hospital_information.hospital_id;";
			ResultSet rs = st.executeQuery(sql);
			JSONObject json = new JSONObject();
			JSONArray arr = new JSONArray();

			int i = 1;
			while (rs.next()) {
				JSONObject details = new JSONObject();
				details.put("type", "hospitals");
				details.put("id", i + "");
				JSONObject attributes = new JSONObject();
				i++;
				String rn = (rs.getInt(1) + "");
				String na = rs.getString(2);
				String pe = rs.getString(3);
				String ad = rs.getString(4);
				String obed = rs.getString(5);
				String ibed = rs.getString(6);
				attributes.put("hid", rn);
				attributes.put("hospital_name", na);
				attributes.put("location", pe);
				attributes.put("normal_beds", ad);
				attributes.put("oxygen_beds", obed);
				attributes.put("icu_beds", ibed);
				details.put("attributes", attributes);
				arr.add(details);
			}
			json.put("data", arr);
			response.getWriter().write(json.toString());

		} catch (Exception e) {
			e.printStackTrace();
		}

	}
}