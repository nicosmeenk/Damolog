package de.hwr.damolog.model;

import java.util.ArrayList;
import java.util.List;

import de.hwr.damolog.controller.Subject;

/**
 * 
 * Speicherung des Datenmodells und die Operationen die der Controlle daruf
 * ausführt
 * 
 * @author nsmeenk
 * 
 */
public class Model extends Subject {

	private List<Checker> _checkers = new ArrayList<Checker>();

	private static final int FIELD_SIZE = 8;

	/**
	 * Konstruktor
	 */
	public Model() {
		resetField();
	}

	/**
	 * Setzt das Feld in den Ausgangszustand zurück
	 */
	private void resetField() {
		_checkers.clear();
		for (int y = 0; y < FIELD_SIZE - 1; y++) {
			for (int x = 0; x < FIELD_SIZE - 1; x++) {
				if (y < FIELD_SIZE / 2 - 1) {
					if (y % 2 + x % 2 == 1) {
						Checker newChecker = new Checker(Color.BLACK, new Point(x, y));
						_checkers.add(newChecker);
					}
				}
				if (y > FIELD_SIZE / 2 + 1) {
					if (y % 2 + x % 2 == 1) {
						Checker newChecker = new Checker(Color.BLACK, new Point(x, y));
						_checkers.add(newChecker);
					}
				}
			}
		}
	}

}
