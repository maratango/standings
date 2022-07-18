package org.xcompany.xprojects.hibernateDao;

import org.hibernate.SessionFactory;
import org.hibernate.Transaction;
import org.hibernate.cfg.Configuration;
import org.hibernate.query.NativeQuery;
import org.hibernate.type.BooleanType;
import org.hibernate.type.IntegerType;
import org.hibernate.type.StringType;
import org.springframework.orm.hibernate5.HibernateTemplate;

import java.util.ArrayList;
import java.util.List;
import java.util.Locale;

public class UserHibernateDao {

	private final SessionFactory factory;
	private final HibernateTemplate hibernateTemplate;
	private final String userCreateSql = "select fn_checkAndAddUser(:p_login, :p_password, :p_email)";
	private final String userPassSql = "select exists(select 1 from users where " +
			"upper(login) = upper(:p_login) and password = :p_password)";
	private final String selectUserTurnsListSql = "select name from tournaments where owner_id = " +
			"(select user_id from users where upper(login) = upper(:p_login) and password = :p_password) " +
			"order by create_date desc";
	private final String selectTurnTableSql = "select * from fn_turnStandings(:p_turnName, :p_login, :p_password)";
	private final String userTurnAddSql = "select fn_checkandaddtournament(:p_newTurnName, :p_login, :p_password)";
	private final String deleteUserTurnSql = "delete from tournaments where tournament_id = " +
			"(select tournament_id from tournaments where name = :p_turnNameForDelete and owner_id = " +
			"(select user_id from users where upper(login) = upper(:p_login) and password = :p_password))";
	private final String turnMatchAddSql = "insert into games values(" +
			"nextval('HIBERNATE_SEQUENCE'), " +
			"(select tournament_id from tournaments where name = :p_turnName and owner_id = " +
			"(select user_id from users where upper(login) = upper(:p_login) and password = :p_password)" +
			"), " +
			":p_t1, " +
			":p_g1, " +
			":p_t2, " +
			":p_g2, " +
			"now())";
	private final String selectTurnMathesSql = "select game_id, home_team, home_goal, guest_team, guest_goal from games where " +
			"tournament_id = (select tournament_id from tournaments where name = :p_turnName" +
			" and owner_id = (select user_id from users where upper(login) = upper(:p_login) and password = :p_password))" +
			" order by create_date desc";
	private final String deleteTurnMatchSql = "delete from games where game_id = :p_matcheIdForDelete";


	public UserHibernateDao() {
		factory = new Configuration().configure().buildSessionFactory();
		Locale.setDefault(Locale.ENGLISH);
		hibernateTemplate = new HibernateTemplate(factory);
	}

	public String create(String login, String password, String email) {
		boolean userRegisterResult;
		try {
			userRegisterResult = hibernateTemplate.<Boolean>executeWithNativeSession(session -> {
				NativeQuery<Boolean> query = session.createSQLQuery(userCreateSql);
				query.addScalar("fn_checkandadduser", BooleanType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE)
						.setParameter("p_email", email, StringType.INSTANCE);
				return query.uniqueResult();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return userRegisterResult ? "OK" : "UserIsExist";
	}

	public String checkAndPass(String login, String password) {
		boolean userPassResult;
		try {
			userPassResult = hibernateTemplate.<Boolean>executeWithNativeSession(session -> {
				NativeQuery<Boolean> query = session.createSQLQuery(userPassSql);
				query.addScalar("exists", BooleanType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				return query.uniqueResult();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return userPassResult ? "OK" : "UserIsNotExist";
	}

	public Object selectUserTurnsList(String login, String password) {
		List<Object> selectTurnsListResult;
		try {
			selectTurnsListResult = hibernateTemplate.<List<Object>>executeWithNativeSession(session -> {
				NativeQuery<Object> query = session.createSQLQuery(selectUserTurnsListSql);
				query.addScalar("name", StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				return query.list();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return selectTurnsListResult;
	}

	public Object selectTurnStandings(String turnName, String login, String password) {
		List<Object> selectTurnStandings;
		try {
			selectTurnStandings = hibernateTemplate.<List<Object>>executeWithNativeSession(session -> {
				NativeQuery<Object> query = session.createSQLQuery(selectTurnTableSql);
				query.addScalar("team", StringType.INSTANCE)
						.addScalar("games", IntegerType.INSTANCE)
						.addScalar("point", IntegerType.INSTANCE)
						.addScalar("win", IntegerType.INSTANCE)
						.addScalar("draw", IntegerType.INSTANCE)
						.addScalar("lose", IntegerType.INSTANCE)
						.addScalar("gs", IntegerType.INSTANCE)
						.addScalar("gc", IntegerType.INSTANCE)
						.addScalar("gd", IntegerType.INSTANCE)
						.setParameter("p_turnName", turnName, StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				return query.list();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return selectTurnStandings;
	}

	public String addNewUserTurnament(String newTurnName, String login, String password) {
		boolean newTurnAddResult;
		try {
			newTurnAddResult = hibernateTemplate.<Boolean>executeWithNativeSession(session -> {
				NativeQuery<Boolean> query = session.createSQLQuery(userTurnAddSql);
				query.addScalar("fn_checkandaddtournament", BooleanType.INSTANCE)
						.setParameter("p_newTurnName", newTurnName, StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				return query.uniqueResult();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return newTurnAddResult ? "OK" : "TurnIsExist";
	}

	public void deleteUserTurn(String turnNameForDelete, String login, String password) {
		try {
			hibernateTemplate.executeWithNativeSession(session -> {
				Transaction txn = session.beginTransaction();
				NativeQuery query = session.createSQLQuery(deleteUserTurnSql);
				query.setParameter("p_turnNameForDelete", turnNameForDelete, StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				query.executeUpdate();
				txn.commit();
				return null;
			});
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
	}

	public String addNewTurnMatch(String newMatchDesc, String turnName, String login, String password) {
		try {
			List<String> elements = getMatchDescElement(newMatchDesc);
			hibernateTemplate.executeWithNativeSession(session -> {
				Transaction txn = session.beginTransaction();
				NativeQuery query = session.createSQLQuery(turnMatchAddSql);
				query.setParameter("p_t1", elements.get(0), StringType.INSTANCE)
						.setParameter("p_g1", Integer.valueOf(elements.get(1)), IntegerType.INSTANCE)
						.setParameter("p_t2", elements.get(2), StringType.INSTANCE)
						.setParameter("p_g2", Integer.valueOf(elements.get(3)), IntegerType.INSTANCE)
						.setParameter("p_turnName", turnName, StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				query.executeUpdate();
				txn.commit();
				return null;
			});
			return "OK";
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
	}

	private List<String> getMatchDescElement(String newMatchDesc) {
		List<String> elements = new ArrayList<>();
		int colonIndex = newMatchDesc.indexOf(":");
		String firstTeamNameAndGoals = newMatchDesc.substring(0, colonIndex);
		String secondTeamAndGoals = newMatchDesc.substring(colonIndex + 1);
		int spaceIndex = firstTeamNameAndGoals.lastIndexOf(" ");
		String firstTeamName = firstTeamNameAndGoals.substring(0, spaceIndex).trim().replace("  ", " ");
		String firstTeamGoals = firstTeamNameAndGoals.substring(spaceIndex + 1);
		spaceIndex = secondTeamAndGoals.indexOf(" ");
		String secondTeamName = secondTeamAndGoals.substring(spaceIndex + 1).trim().replace("  ", " ");
		String secondTeamGoals = secondTeamAndGoals.substring(0, spaceIndex);

		elements.add(firstTeamName);
		elements.add(firstTeamGoals);
		elements.add(secondTeamName);
		elements.add(secondTeamGoals);
		return elements;
	}

	public Object selectTurnMatches(String turnName, String login, String password) {
		List<Object> selectTurnMatches;
		try {
			selectTurnMatches = hibernateTemplate.<List<Object>>executeWithNativeSession(session -> {
				NativeQuery<Object> query = session.createSQLQuery(selectTurnMathesSql);
				query.addScalar("game_id", IntegerType.INSTANCE)
						.addScalar("home_team", StringType.INSTANCE)
						.addScalar("home_goal", IntegerType.INSTANCE)
						.addScalar("guest_team", StringType.INSTANCE)
						.addScalar("guest_goal", IntegerType.INSTANCE)
						.setParameter("p_turnName", turnName, StringType.INSTANCE)
						.setParameter("p_login", login, StringType.INSTANCE)
						.setParameter("p_password", password, StringType.INSTANCE);
				return query.list();
			});
		} catch (Exception e) {
			e.printStackTrace();
			return "Error";
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
		return selectTurnMatches;
	}

	public void deleteTurnMatch(int matcheIdForDelete) {
		try {
			hibernateTemplate.executeWithNativeSession(session -> {
				Transaction txn = session.beginTransaction();
				NativeQuery query = session.createSQLQuery(deleteTurnMatchSql);
				query.setParameter("p_matcheIdForDelete", matcheIdForDelete, IntegerType.INSTANCE);
				query.executeUpdate();
				txn.commit();
				return null;
			});
		} catch (Exception e) {
			e.printStackTrace();
		} finally {
			if (factory != null) {
				factory.close();
			}
		}
	}
}
