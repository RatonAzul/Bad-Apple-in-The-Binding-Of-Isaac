import cv2

# This code takes the Bad Apple video as an input and outputs its frames to a Lua file as a table of 14x14 matrices
# which store if that area of the frame is black or white.

# VARIABLES
matrices = []  # array to store the matrices
matrixSize = 14
fps = 3  # the video runs at 30fps but this code only takes 3 frames per second
videoInput = 'BadApple.mp4'
luaOutput = 'frametable3.lua'

# capture the video and render the frames
video = cv2.VideoCapture(videoInput)
frameCount = 0  # move this outside the loop
while video.isOpened():
    ret, frame = video.read()
    if not ret:
        break

    # skip frames so it only takes 3 per second
    if frameCount % (30 // fps) != 0:
        frameCount += 1
        continue

    # grayscale and resize it
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    resized = cv2.resize(gray, (matrixSize, matrixSize))

    # threshold the frame to get the black and white pixels
    _, threshold = cv2.threshold(resized, 128, 1, cv2.THRESH_BINARY)

    # add matrix to the list
    matrices.append(threshold.astype(int).tolist())

    # increment the frame count
    frameCount += 1

# save the matrices to a lua table
with open(luaOutput, 'w') as f:
    f.write('frames = {\n')
    for i, matrix in enumerate(matrices):
        f.write('{\n')
        for row in matrix:
            f.write('{')
            for value in row:
                f.write(str(value) + ',')
            f.write('},\n')
        f.write('}')
        if i != len(matrices) - 1:
            f.write(',')
        f.write('\n')
    f.write('}\n')


