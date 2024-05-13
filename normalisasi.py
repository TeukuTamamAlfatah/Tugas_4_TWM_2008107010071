def read_dictionary(file_path):
    dictionary = {}
    with open(file_path, 'r') as file:
        for line in file:
            # Split jadi freq dan word
            split_line = line.strip().split('\t')
            # harus di cek karena dianatara baris ada baris kosong
            if len(split_line) == 2:
                freq, word = split_line
                dictionary[word] = int(freq)
            else:
                # skip baris kosong
                continue
    return dictionary

def normalize(dictionary):
    total_freq = sum(dictionary.values())
    return {word: round((freq / total_freq)*100, 2) for word, freq in dictionary.items()}

def eliminate_duplicates(dict1, dict2, threshold):
    eliminated_words = set()
    for word, freq1 in dict1.items():
        if word in dict2:
            freq2 = dict2[word]
            v = min(freq1, freq2) / max(freq1, freq2)
            if v >= threshold:
                eliminated_words.add(word)
    return eliminated_words

def filter_dictionary(dictionary, eliminated_words):
    return {word: freq for word, freq in dictionary.items() if word not in eliminated_words}

def write_dictionary(dictionary, file_path):
    with open(file_path, 'w') as file:
        for word, freq in dictionary.items():
            file.write(f"{freq}\t{word}\n")

# Path to dictionary files
file_path_dict1 = "finance_grams/finance_3grams.txt"
file_path_dict2 = "sport_grams/sport_3grams.txt"

# Read dictionaries
dict1 = read_dictionary(file_path_dict1)
dict2 = read_dictionary(file_path_dict2)

# Normalize frequencies
dict1 = normalize(dict1)
dict2 = normalize(dict2)

# Set threshold
threshold = 0.50

# Eliminate duplicates
eliminated_words = eliminate_duplicates(dict1, dict2, threshold)

# Filter dictionaries
filtered_dict1 = filter_dictionary(dict1, eliminated_words)
filtered_dict2 = filter_dictionary(dict2, eliminated_words)

write_dictionary(filtered_dict1, "kamus_grams/dictionary_three_grams.txt")