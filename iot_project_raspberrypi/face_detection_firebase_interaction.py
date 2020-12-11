import numpy as np
import cv2
import pickle
from firebase import firebase
# This is the model used for the detection
face_cascade = cv2.CascadeClassifier('haarcascades/haarcascade_frontalface_alt2.xml')

cap = cv2.VideoCapture(0)
firebase = firebase.FirebaseApplication("https://esp8266-flutter-test.firebaseio.com",None)

while(True):
    # Capture frame-by-frame
    ret, frame = cap.read()
    # Convert the image into greyscale
    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
    face = face_cascade.detectMultiScale(gray, scaleFactor=3, minNeighbors=5)
    # More the scaleFactor is high, more the detection is precise

    for(x, y, w, h) in face:
        #print(x, y, w, h) # print the position where the object is detected
        # the area where the patern is detected is called Region Of Interest (roi)
        roi_gray = gray[y:y+h, x:x+w] # The roi detected in the greyscale image
        start_coord_x = x
        start_coord_y = y
        end_coord_x = x+w
        end_coord_y = y+h
        # The roi is the same for the greyscale and the colored image
        roi_color = frame[y:y + h, x:x + w]

        # We create a rectangle around the face
        color = (250, 0, 0)  # equivalent à BGR 0-255
        stroke = 2  # the thinkness of the rectangle
        cv2.rectangle(frame, (start_coord_x, start_coord_y), (end_coord_x, end_coord_y), color, stroke)

        firebase.put('/sensors/Json/', 'face_detected', 1)

    if len(face) == 0:
        firebase.put('/sensors/Json/', 'face_detected', 0)
    #result = firebase.get('/esp8266-flutter-test/sensors/Json', None)

    # Display the resulting frame
    cv2.imshow('frame', frame)
    if cv2.waitKey(20) & 0xFF == ord('q'):
        break

# When everything done, release the capture
cap.release()
cv2.destroyAllWindows()