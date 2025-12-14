package bean;

import java.io.Serializable;
import java.sql.Timestamp;

public class Member implements Serializable {
    private static final long serialVersionUID = 1L;

    private String id;
    private String name;
    private String password;
    private Timestamp updatedAt;

    public Member() {}

    public String getId() { return id; }
    public String getName() { return name; }
    public String getPassword() { return password; }
    public Timestamp getUpdatedAt() { return updatedAt; }

    public void setId(String id) { this.id = id; }
    public void setName(String name) { this.name = name; }

    public void setPassword(String password) { this.password = password; }

    public void setUpdatedAt(Timestamp updatedAt) { this.updatedAt = updatedAt; }
}
