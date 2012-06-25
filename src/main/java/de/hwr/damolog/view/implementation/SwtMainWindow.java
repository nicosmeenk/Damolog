package de.hwr.damolog.view.implementation;

import org.eclipse.swt.graphics.Point;
import org.eclipse.swt.graphics.Rectangle;
import org.eclipse.swt.widgets.Display;
import org.eclipse.swt.widgets.Shell;

import de.hwr.damolog.controller.IController;
import de.hwr.damolog.view.IObservingView;

/**
 * 
 * Hauptfenster
 * 
 * @author nsmeenk
 * 
 */
public class SwtMainWindow implements IObservingView {

	private IController _controller;

	/**
	 * Konstruktor
	 */
	public SwtMainWindow() {
		Display display = new Display();
		final Shell shell = new Shell(display);

		shell.setText("Damolog");

		shell.pack();
		centerWindow(shell);

		shell.open();
		while (!shell.isDisposed()) {
			if (!display.readAndDispatch()) {
				display.sleep();
			}
		}
		display.dispose();
	}

	/**
	 * Zentriert das Fenster der übergeben Shell
	 * 
	 * @param shell
	 *            Shell
	 */
	private void centerWindow(Shell shell) {
		Rectangle bounds = shell.getDisplay().getBounds();
		Point point = shell.getSize();
		int left = (bounds.width - point.x) / 2;
		int top = (bounds.height - point.y) / 2;
		shell.setBounds(left, top, point.x, point.y);
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see
	 * de.hwr.damolog.view.IObservingView#setController(de.hwr.damolog.controller
	 * .IController)
	 */
	@Override
	public void setController(IController pController) {
		_controller = pController;
	}

	/*
	 * (non-Javadoc)
	 * 
	 * @see de.hwr.damolog.controller.IObserver#update(java.lang.Object)
	 */
	@Override
	public void update(Object pChanged) {
		// TODO Auto-generated method stub

	}

}
