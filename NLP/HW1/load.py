
# Function to load a given grammar file into a dictionary
def load(filename):
	gramm = open(filename, "r")
	rules = {}

	while True:
		line = gramm.readline()
		if not line: # reached end of file
			break

		if(line.find('#') == 0): # is solely a commented line
			continue

		presplit = line.split('#') # To account for comments in line
		tokens = presplit[0].split() 

		if(len(tokens) == 0): # if empty line go next
			continue
	
		relodds = tokens[0]
		lhs = tokens[1]
		rhs = tokens[2::]
		rules.setdefault(lhs,[])
		rules[lhs].append([relodds, rhs])
		#rules[lhs].append(rhs)
	gramm.close()

	# Section below turn relative odds of occurence into probabilities
	for lhs in rules:
		total = 0
		possibles = rules[lhs]
		for occurence in possibles:
			total += float(occurence[0]) # getting the relative odds of that occurrence
		for occurence in possibles:
			occurence[0] = float(occurence[0]) / total

	#print rules
	return rules




