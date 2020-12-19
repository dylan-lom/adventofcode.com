import os
import sys
import binascii
from Crypto.Cipher import AES

plain1 = "################".encode()
plain2 = "#              #".encode()
plain3 = "#    START     #".encode()
plainX = "#     END      #".encode()
plainStart = [plain1, plain2, plain3, plain2, plain1]
plainEnd = [plain1, plain2, plainX, plain2, plain1]

key = b'0000000000009999'
cipher = AES.new(key, AES.MODE_ECB)
debug = False


def run_xor(b1, b2):
    if len(b1) != len(b2):
        print("XOR: mismatching length of byte arrays")
        exit(-1)
    
    output = []

    if debug: print("DEBUG @ RUN_XOR")
    for i in range(0, len(b1)):
        x = b1[i] ^ b2[i]
        if debug: print("%d ^ %d = %d" % (b1[i], b2[i], x))
        t = "%x" % x
        if len(t) == 1:
            t = "0" + t
        output.append(t)
    return "".join(output)



def transcrypt(nonce, input_text):
    # Buffer
    enc_nonce = cipher.encrypt(nonce)
    print('TRANSCRYPT ENC_NONCE: ', enc_nonce)
    # String
    ciphertext = run_xor(enc_nonce, input_text)
    return ciphertext



def encrypt_input_file(filename):
    with open(filename, "r") as infh, open("encrypted.enc", "w") as outfh:
        i = 0
        for line in infh:
            line = line.rstrip("\n")
            nonce = "000000000000000" + str(i)
            res = transcrypt(nonce.encode(), line.encode())
            outfh.write(str(i) + "," + res + "\n")
            i = (i + 1) % 10


def bruteforce_key(nonce, plain_text, enc_text):
    key = b''
    for inc in range(2 ** 128):
        key = str(inc).zfill(16).encode()
        global cipher 
        cipher = AES.new(key, AES.MODE_ECB)
        nonce = "0000000000000001" 
        res = transcrypt(nonce.encode(), plain_text)
        # print(str(0) + "," + res + "\n")
        sys.stdout.write('\r')
        sys.stdout.flush()
        sys.stdout.write("%d / %d (%s)" % (inc, 2 ** 128, key))
        if (res == enc_text):
            print('FOUND KEY: ' + key)
            break
    return key

def enc_text_to_enc_text_i(enc_text):
    split_enc_text = [enc_text[i:i+2] for i in range(0, len(enc_text), 2)]
    return list(map(
        lambda h: int(h, 16),
        split_enc_text
    ))

# We can calculate the enc_nonce with (enc_text ^ plain_text)
# @parameter plain_text_b: Ascii characters, converted to bytes with
# string.encode()
# @parameter enc_text: 32 2-wide hex characters as a string (result of run_xor 
# proccess)
# @return: enc_nonce as byte array.
def extract_enc_nonce_from_enc_text(plain_text_b, enc_text):
    # convert enc_text into a int array - plain_text
    enc_text_i = enc_text_to_enc_text_i(enc_text)

    # check input is same length
    if (len(plain_text_b) != len(enc_text_i)):
        print(
            'Mismatching length of plain_text and enc_text: %s, %s' %
            (len(plain_text_b), len(enc_text_i))
        )
        exit(1)

    enc_nonce_i = []
    enc_nonce_h = []
    enc_nonce_a = []
    if debug: print("DEBUG @ EXTRACT")
    for i in range(0, len(plain_text_b)):
        xor_res = plain_text_b[i] ^ enc_text_i[i]
        if debug: print("%d ^ %d = %d" % (plain_text_b[i], enc_text_i[i], xor_res))
        enc_nonce_i.append(xor_res)
        enc_nonce_h.append("%x" % xor_res)
        enc_nonce_a.append(chr(xor_res))

    enc_nonce_b = bytes(enc_nonce_i)
    if debug:
        print("EXTRACT ENC_NONCE_B: ", enc_nonce_b)
        print("EXTRACT ENC_NONCE_I: ", enc_nonce_i)
        print("EXTRACT ENC_NONCE_H: ", enc_nonce_h)
        print("EXTRACT ENC_NONCE_A: ", enc_nonce_a)

    return enc_nonce_b

def extract_plain_text_from_enc_text(enc_text, enc_nonce):
    enc_text_i = enc_text_to_enc_text_i(enc_text)

    # check input is same length
    if (len(enc_text_i) != len(enc_nonce)):
        print(
            'Mismatching length of plain_text and enc_text: %s, %s' %
            (len(enc_text_i), len(enc_nonce))
        )
        exit(1)
    
    plain_text_i = []
    if debug: print("DEBUG @ EXTRACT_PLAIN")
    for i in range(0, len(enc_text_i)):
        xor_res = enc_text_i[i] ^ enc_nonce[i]
        if debug: print("%d ^ %d = %d" % (enc_text_i[i], enc_nonce[i], xor_res))
        plain_text_i.append(xor_res)

    plain_text = list(map(chr, plain_text_i))
    return "".join(plain_text)
    
def decrypt_input_file(filename, enc_nonces):
    with open(filename, "r") as infh:
        for line in infh:
            line = line.rstrip('\n')
            nonce_index = int(line[0])
            line = line[2:] # remove leading meta-information
            print(extract_plain_text_from_enc_text(line, enc_nonces[nonce_index]))

def break_input_file(filename):
    # YOUR JOB STARTS HERE
    global debug

    nonce = '0000000000000000'.encode()
    enc_nonce = b''
    plain_text = plain1
    enc_text = '4057562b7defa5579e65a89c7d75be51'

    known_inputs_and_outputs = [
        # First 5 lines
        (plain1, '4057562b7defa5579e65a89c7d75be51'),
        (plain2, '4ab02d7212cac09e19556e9219015dba'),
        (plain3, '07fcabab33fe99c591d306a265dcfc6d'),
        (plain2, '6ada24b26ab082f67a8558fbc91b8b26'),
        (plain1, '7bf4de2a378fadc61e183b2de7df565e'),
        # Last 5 lines
        (plain1, 'f156934d23017db471602d923b5e5f4d'),
        (plain2, '1948504d3a2cb35178a554b1fc28da68'),
        (plainX, '6bab2b39e6f8592519ac020470fe5fa2'),
        (plain2, '148d2f52ca1fe6975ce1975384df9dd8'),
        (plain1, '61ecf0d7414b2ad4962903c4e13ba44a'),
    ]

    # known_inputs_and_outputs[0] = (plain1, '9c9adcfdf0c646bd7a12bfedcf05bd07')

    # since ECB encryption is in use, and line numbers work nicely, enc_nonces
    # contain all the generated nonces (for ln 0-9). Also disable debug so
    # output isn't completed flooded.
    _debug = debug
    debug = False
    enc_nonces = [
        extract_enc_nonce_from_enc_text(io[0], io[1])
        for io in known_inputs_and_outputs
    ]
    debug = _debug

    if debug:
        enc_text = transcrypt(nonce, plain_text)
        print('TRANSCRYPT ENC_TEXT: ', enc_text)

        print('EXTRACTED ENC_NONCE: ', enc_nonces[0])
        print('EXTRACTED PLAIN_TEXT: ', extract_plain_text_from_enc_text(known_inputs_and_outputs[1][1], enc_nonces[1]))


    decrypt_input_file(filename, enc_nonces)
    # Takes too long.
    # print(bruteforce_key('0000000000000000', plain1, '4057562b7defa5579e65a89c7d75be51'))

    #print("EXTRACT ENC_NONCE: ", extract_enc_nonce_from_enc_text(plain_text, enc_text))
    # YOUR JOB ENDS HERE
    pass


def main(args):
    if len(args) > 1:
        filename = args[1]
        break_input_file(filename)
    else:
        print("Please provide an file to break!")

if __name__ == '__main__':
    main(sys.argv)
