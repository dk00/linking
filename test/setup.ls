import jsdom: { JSDOM }

{global.window} = new JSDOM '<!doctype html><html><body></body></html>'
global{document, navigator} = global.window

