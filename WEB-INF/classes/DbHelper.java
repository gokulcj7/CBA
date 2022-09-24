import java.sql.*;
import java.util.ArrayList;

public class DbHelper {

    public static ResultSet GetResult(String query) throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
        Statement st = con.createStatement();

        ResultSet rs = st.executeQuery(query);
        return rs;
    }

    public static void insertPS(String query, ArrayList<String> list) throws SQLException {
        Connection con = DriverManager.getConnection("jdbc:mysql://localhost/covid", "root", "Gokul@2001");
        PreparedStatement st = con.prepareStatement(query);

        for (int i = 0; i < list.size(); i++) {
            if (i + 1 == 4 || i + 1 == 5 || i + 1 == 6) {
                st.setInt(i + 1, Integer.parseInt(list.get(i)));
            } else {
                st.setString(i + 1, list.get(i));
            }
        }
        st.executeUpdate();
    }

}
