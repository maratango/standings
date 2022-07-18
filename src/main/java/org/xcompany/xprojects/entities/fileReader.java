package org.xcompany.xprojects.entities;

import org.hibernate.SessionFactory;
import org.hibernate.cfg.Configuration;
import org.xcompany.xprojects.hibernateDao.MatchHibernateDAO;

import java.io.File;
import java.io.FileNotFoundException;
import java.util.List;
import java.util.Locale;
import java.util.Scanner;

public class fileReader {

    public void readFileWriteBD(File file) throws FileNotFoundException {

        //создаём Сканер, указываем путь до файла чтения
        Scanner sc = new Scanner(file);

        //подготовка к связи с бд
        SessionFactory factory = null;
        Locale.setDefault(Locale.ENGLISH);

        //чтение файла и запись в бд
        try {
            factory = new Configuration().configure().buildSessionFactory();
            MatchHibernateDAO matchHibernateDao = new MatchHibernateDAO(factory);

            while(sc.hasNext()) {
                final Match match = new Match();
                match.setHome_team(sc.next());
                match.setHome_goal(sc.nextInt());
                match.setGuest_team(sc.next());
                match.setGuest_goal(sc.nextInt());
                matchHibernateDao.create(match);
            }

        } catch (Exception e) {
            e.printStackTrace();
        }  finally {
            if (factory != null) {
                factory.close();
            }
        }

    }

}
