
from collections import Counter
import random
import time
import matplotlib.pyplot as plt


cdef int* primes = [
    2, 3, 5, 7, 11, 13, 17, 19, 23, 29, 31, 37, 41, 43, 47, 53, 59, 61, 67, 71, 73, 79, 83, 89, 97, 101
]

def anagram_primes(const char* str1, const char* str2, int length):
    prod1 = 1
    for i in range(length):
        prod1 *= primes[str1[i] - 97]
    prod2 = 1
    for i in range(length):
        prod2 *= primes[str2[i] - 97]
    return prod1 == prod2

def anagram_counter(str1: bytes, str2: bytes):
    return Counter(str1) == Counter(str2)

def anagram_sort(str1: bytes, str2: bytes):
    return sorted(str1) == sorted(str2)

cdef bint anagram_array(const char* str1, const char* str2, int length):
    # Init array of 26 cells set to 0 (one for each letter)
    cdef int counter[26]
    for i in range(26):
        counter[i] = 0

    for i in range(length):
        counter[str1[i] - 97] += 1
        counter[str2[i] - 97] -= 1

    # Check that all cells are still zero
    for i in range(26):
        if counter[i] != 0:
            return False
    return True

def generate_random_chars(size):
    chars = 'abcdefghijklmnopqrstuvwxyz'
    return [
        random.choice(chars)
        for _ in range(size)
    ]

def bench():
    sizes = [
        100 * p
        for p in range(1, 1000)
        if (100 * p) < 20000
    ]
    iterations = 5
    cdef char* chars1
    cdef char* chars2

    timings_array = []
    timings_counter = []
    timings_primes = []
    timings_sort = []

    for size in sizes:
        print('>> Bench for size %s' % size)
        chars = generate_random_chars(size)
        str1 = ''.join(chars).encode('utf-8')
        chars1 = str1
        random.shuffle(chars)
        str2 = ''.join(chars).encode('utf-8')
        chars2 = str2

        # Anagram Array
        t0 = time.time()
        for _ in range(iterations):
            anagram_array(chars1, chars2, size)
        total = time.time() - t0
        per_call = total / iterations
        timings_array.append(per_call)
        print('anagram_array %s per/call' % per_call)

        # Anagram Counter
        t0 = time.time()
        for _ in range(iterations):
            anagram_counter(str1, str2)
        total = time.time() - t0
        per_call = total / iterations
        timings_counter.append(per_call)
        print('anagram_counter %s per/call' % per_call)

        # Anagram Sort
        t0 = time.time()
        for _ in range(iterations):
            anagram_sort(str1, str2)
        total = time.time() - t0
        per_call = total / iterations
        timings_sort.append(per_call)
        print('anagram_sort %s per/call' % per_call)

        # Anagram Primes
        t0 = time.time()
        for _ in range(iterations):
            anagram_primes(chars1, chars2, size)
        total = time.time() - t0
        per_call = total / iterations
        timings_primes.append(per_call)
        print('anagram_primes %s per/call' % per_call)

    # Plotting
    y = [str(size) for size in sizes]
    plt.plot(
        y, timings_array, 'r--',
        y, timings_counter, 'bs',
        y, timings_primes, 'g^',
        y, timings_sort, 'g+',
    )
    plt.savefig('anagrams.png')
    plt.show()
