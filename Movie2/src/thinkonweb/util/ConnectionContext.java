package thinkonweb.util;

import javax.naming.*;
import javax.sql.DataSource;
import java.sql.Connection;
import java.sql.SQLException;

public class ConnectionContext {
    private static final String JNDI_NAME = "jdbc/movieDB"; // web.xml, context.xml과 동일하게
    private static DataSource ds;

    static {
        try {
            Context env = (Context) new InitialContext().lookup("java:comp/env");
            ds = (DataSource) env.lookup(JNDI_NAME);
        } catch (Exception e) {
            throw new RuntimeException("JNDI lookup failed: " + JNDI_NAME, e);
        }
    }

    public static Connection getConnection() throws SQLException {
        // 매 호출마다 풀에서 빌림 (close() 하면 풀로 반납됨)
        return ds.getConnection();
    }
}
