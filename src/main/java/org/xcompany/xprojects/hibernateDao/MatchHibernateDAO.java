package org.xcompany.xprojects.hibernateDao;

import org.hibernate.Session;
import org.hibernate.SessionFactory;
import org.xcompany.xprojects.entities.Match;

import java.util.List;

public class MatchHibernateDAO {

    private final SessionFactory factory;

    public MatchHibernateDAO(final SessionFactory factory) {
        this.factory = factory;
    }

    public void create(final Match match) {
        try (final Session session = factory.openSession()) {
            session.beginTransaction();
            session.save(match);
            session.getTransaction().commit();
        }
    }

    public Match read(final Integer id) {
        try (final Session session = factory.openSession()) {
            final Match result = session.get(Match.class, id);
            return result != null ? result : new Match();
        }
    }

    public void update(final Match match) {
        try (Session session = factory.openSession()) {
            session.beginTransaction();
            session.update(match);
            session.getTransaction().commit();
        }
    }

    public void delete(final Match match) {
        try (Session session = factory.openSession()) {
            session.beginTransaction();
            session.delete(match);
            session.getTransaction().commit();
        }
    }

    public List<Object[]> turnTableMaking () {
        try (Session session = factory.openSession()) {
            session.beginTransaction();
            List<Object[]> turnTable = session.createSQLQuery("select * from turnTable").list();
            return turnTable;
        }
    }
}
