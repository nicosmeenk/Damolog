package de.hwr.damolog.controller;

import java.util.ArrayList;
import java.util.List;

/**
 * 
 * ein Subjekt, welches von Observern beobachtet werden kann
 * 
 * @author nsmeenk
 * 
 */
public abstract class Subject {

	private List<IObserver> _observers = new ArrayList<IObserver>();

	/**
	 * Fügt dem Subjekt einen Beobachter hinzu
	 * 
	 * @param pObserver
	 *            Beobachter zum hinzufügen
	 */
	public void addObserver(IObserver pObserver) {
		_observers.add(pObserver);
	}

	/**
	 * entfernt einen Beobachte vom Projekt
	 * 
	 * @param pObserver
	 *            Beobachter zum entfernen
	 */
	public void removeObserver(IObserver pObserver) {
		_observers.remove(pObserver);
	}

	/**
	 * gibt ein Update an alle beobachtenden Objekte
	 */
	public void updateObserver(Object pChanged) {
		for (IObserver observer : _observers) {
			observer.update(pChanged);
		}
	}
}
