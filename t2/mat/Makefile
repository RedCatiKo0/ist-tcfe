octave.log: t2.m
	octave $< > $@
	mv -f *.tex ../doc

clean:
	@rm -f octave.log octave-workspace *.eps *~

.PHONY: clean