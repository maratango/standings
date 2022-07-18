package org.xcompany.xprojects.entities;

import lombok.Getter;
import lombok.Setter;

import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.SequenceGenerator;

@Getter
@Setter
public class User {
	@SequenceGenerator(name = "jUsersSequence", sequenceName = "usersSequence")
	@GeneratedValue(strategy = GenerationType.SEQUENCE, generator = "jUsersSequence")
	private Integer user_id;
	private String login;
	private String password;
	private String email;

	public User(String login, String password, String email) {
		this.login = login;
		this.password = password;
		this.email = email;
	}
}
