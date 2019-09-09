import numpy as np

# Function to generate a sentence given a set of rules.
def generate(rules, tree):
	sentence = 'ROOT'
	tokens = sentence.split()

	treeString = ''



	i = 0
	while(notDone(tokens, rules)):

		#for i in range(mini, len(tokens)):
			#print sentence

			if (tokens[i] in rules): # not a terminal
				treeString = treeString + ' ' + tokens[i]

				possibles = rules[tokens[i]] # all possible RHS for given token
				prob = []
				for occurence in possibles:
	 				prob.append(occurence[0])
		
				replacementInd = np.random.choice(len(possibles), p = prob)
				replacement = possibles[replacementInd]
				tokens[i] = ' '.join(replacement[1])
				sentence = ' '.join(tokens)
				tokens = sentence.split()

			else: # we have reached a terminal
				treeString = treeString + ' ' + tokens[i]
				i = i + 1





	if (tree):
		treeString = treeString + ' '  +  sentence.split()[-2] + ' ' + sentence.split()[-1]
		print treeString
	return sentence

# Function to check if a set of tokens consists only of terminals
def notDone(tokens, rules):
	for word in tokens:
		if (word in rules): # means key exists, ie not terminal
			return True
	return False
