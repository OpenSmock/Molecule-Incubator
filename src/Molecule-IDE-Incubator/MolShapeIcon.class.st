"
Please comment me using the following template inspired by Class Responsibility Collaborator (CRC) design:

For the Class part:  I am used so that the more complex shapes of the component's contract (its required part) can be correctly highlighted

For the Responsibility part: Three sentences about my main responsibilities - what I do, what I know.

For the Collaborators Part: State my main collaborators and one line about how I interact with them.

Public API and Key Messages

- message one
- message two
- (for bonus points) how to create instances.

   One simple example is simply gorgeous.

Internal Representation and Key Implementation Points.


    Implementation Points
"
Class {
	#name : #MolShapeIcon,
	#superclass : #Object,
	#classInstVars : [
		'icons'
	],
	#category : #'Molecule-IDE-Incubator-ComponentIDE'
}

{ #category : #accessing }
MolShapeIcon class >> consumedEventIcon [

	<script: 'self consumedEventIcon inspect'>
	^ self icons at: #consumedEvent ifAbsentPut: [
		  Form fromBinaryStream:
			  self consumedEventIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> consumedEventIconEncoding [
	"to import a Form inside Pharo (and get this type of String), follow this procedure
	- import your PNG inside your Pharo image folder (first layer, not inside pharo-local)
	- execute in a Playground
	ImageReadWriter formFromFileNamed: 'test.png' 
	to visualize your PNG
	- execute in a Playground
	(Base64MimeConverter mimeEncode: 'test.png' asFileReference binaryReadStream) contents
	to get the representation of the PNG as a String
	The methods that are not suffixed Encoding have to code to use this representation in Pharo"

	^ 'iVBORw0KGgoAAAANSUhEUgAAACUAAABHCAYAAACAoo5SAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAHqSURBVGhD7dkxqsJAEMbxgOIJvIRe
w4MYLW3s9AYqeIlcwFKwsLSxVCvTWOohlJUvbB7hFS8zOzPLK/YPAR3Z8HMLw2Lm/mEJRS2h
qJFQj8fDv4oTCbVcLt1ms/Hv7COjsixzi8XCT2wjoWazWYXCFWPHWDsVC8ZCbbdb1+/3zWEs
1OFwcNfr1RzGRiFrWBAKWcKCUagJW6/XfipPhEIWMDEKacNUUEgTpoZCWjBVFNKAqaOQFMZC
cX6PbrdbMIyEOh6PrtfruW6363a7nZ+2FwojodB+vxfDVquVn/4dGYViwVgoFAPGRiFrWBAK
WcKCUcgKJkIhC5gYhbRhKihUwzqdjghWlqUeCuExhJtjx+73u5+2hycG1uGaTqd6qMvl8vON
Oc/I1+vlhsNhtW48HrvT6aSD0gK93+9qLkZpg5AIZQFCwSgrEApCWYIQG2UNQixUDBAioySg
wWBQrcvzvBWESKjm6cQahEio+jQzn8/9pL1QEGKhqOc+CQipo6QgpIrSACE1lBYIqaCez6ca
CIlR2iAkQjVBk8lEBYSCUb9Bn8/HfyIvCGUJQmyUNQixUEVRmIMQC1VfliBEQjX/77MGIdZO
jUYjcxAio2LsUB0JdT6fo4EQCRW7hKKWUNQSilpCUUsoWs59AZqbJdnYcIWKAAAAAElFTkSu
QmCC'
]

{ #category : #accessing }
MolShapeIcon class >> icons [

	<script: 'self icons inspect'>
	icons ifNil: [ icons := Dictionary new ].
	^ icons
]

{ #category : #accessing }
MolShapeIcon class >> redConsumedEventIcon [

	<script: 'self redConsumedEventIcon inspect'>
	^ self icons at: #consumedEventRed ifAbsentPut: [
		  Form fromBinaryStream:
			  self redConsumedEventIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> redConsumedEventIconEncoding [

	^ 'iVBORw0KGgoAAAANSUhEUgAAACUAAABHCAYAAACAoo5SAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAAK0SURBVGhD7dq7qxpBFMDhExU7O7uk
TKPg/xAfjUllsPcBabVc7cV3mcLCIo2NIKk0IKJF0kgC8YHYWgULU9klyt49c8dwucg6u3Nm
MbA/EMe7OHx3d3Fc9YVuBHeWh9/fVS5KtP8Xtdvt+MiZhFCdTgcajQZ/pD7hw1cqlUDTNP5I
bUKo4/HI7pvNpiN7TAgVCAT46HGPqYYJHz6s1WpBMBhUDrOEikQiMJ1OlcMsobCXb98rh1lG
YaphtlDYc1i9Xudb5LONwp7CyuUyGUwKhamASaMwahgJCqOEkaEwKhgpCqOAWUItFgs+Mg9h
s9nMPgyvZm41mUx0v9+v+3w+fTAY6L9fvRa6rddr3YDh1ZJeq9X4bLcTQmHD4VAaVq1W+Wzm
CaMwp2CWUJgTMMsoTDXMFgpTCbONwlTBpFCYCpg0CqOGkX0UNBqNIJVKwfl8hn6/D2+KYteI
v758hmg0CofDAQwYpNNpIP18Ct8W47tQY4/BZrOBYPwd32Lez08dSCQSbJzP5+kW5NVqBe12
m40rlYow6O+Pb1AoFNg4k8kwFMk5tVwu/50bxuJ79fy5dtvv93o4HGbPM0D66XRi80mjqEGY
FEoFCLONUgXCbKFUgjDLKNUgzBLKCRAmjJIBhUIh9rxsNnsThAmhjBdGx0CY0Ct6r9dja1Ox
WIQPH7v8r+bhKzWuadvtFgwQdLtd8Hq9fKt5lpaZZDLJR+bJgDDyi1FZEEaKogBhZCgqEEaC
+vP9KxkIk0YhKBaLkYEwKdRTUC6XIwFhtlGqQJgt1DWQx0NyerIsz6QahFmazVjLlINYfA00
TdM0tqhebgZIN67v+Fb6hP7Ny/d9mNI9xBOa+fJ9XzweVw7ChGfHPTQej5WDWPwwmjafz5We
Q89zf+simosSzUWJ5qJEc1Gi3SEK4AGaVzF5mszzwAAAAABJRU5ErkJggg=='
]

{ #category : #accessing }
MolShapeIcon class >> redUsedParameterIcon [

	<script: 'self redUsedParameterIcon inspect'>
	^ self icons at: #usedParameterRed ifAbsentPut: [
		  Form fromBinaryStream:
			  self redUsedParameterIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> redUsedParameterIconEncoding [

	^ 'iVBORw0KGgoAAAANSUhEUgAAAEwAAAAmCAYAAABu+H0XAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAACbSURBVGhD7dohDsJAAEXBhSPgkdz/
QEg8VwBESVDNPgQUMmO6ti/7U9Pd7WF82fV4Wk5jHC7n5bRN++XJJMGi1Um+TuXfvDt9NywS
LJqe5Na/XrOe72SSHyJYJFgkWCRYJFgkWCRYJFgkWCRYJFgkWCRYJFgkWCRYJFgkWCRYJFgk
WCRYJFi0id+dfokbFgkWCRYJFgkWCZaMcQcR+xw57fxPiAAAAABJRU5ErkJggg=='
]

{ #category : #accessing }
MolShapeIcon class >> redUsedServiceIcon [

	<script: 'self redUsedServiceIcon inspect'>
	^ self icons at: #usedServiceRed ifAbsentPut: [
		  Form fromBinaryStream:
			  self redUsedServiceIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> redUsedServiceIconEncoding [

	^ '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
sb6NDwAAAABJRU5ErkJggg=='
]

{ #category : #accessing }
MolShapeIcon class >> usedParameterIcon [

	<script: 'self usedParameterIcon inspect'>
	^ self icons at: #usedParameter ifAbsentPut: [
		  Form fromBinaryStream:
			  self usedParameterIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> usedParameterIconEncoding [

	^ 'iVBORw0KGgoAAAANSUhEUgAAAEwAAAAmCAYAAABu+H0XAAAAAXNSR0IArs4c6QAAAARnQU1B
AACxjwv8YQUAAAAJcEhZcwAAEnQAABJ0Ad5mH3gAAADmSURBVGhD7dqxbYNgEEBhavZgAgQd
S9CzCBVz0DIAFTUFDVOwAiNclOhXmkQkT7Yl23qfdM1RoHu0ZPEEjuOILMuibdu0eV4GgwwG
/Rls27ZYluWhM01TlGUZXdf9+vzec55nuo67DLbv+9eXf7ep6zpdyF0Gm+f5+yV937/FfN5S
FEW6kPtXsGEY0ub15XluMMJgkMEgg0EGgwwGGQwyGGQwyGCQwSCDQQaDDAYZDDIYZDDIYJDB
IINBBoMMBhkMemiwdV2jqqoYxzFtXl/TNDf9w3EZTD8ZDDIYZDDIYJDBIIMhER9QIavc3mxd
MAAAAABJRU5ErkJggg=='
]

{ #category : #accessing }
MolShapeIcon class >> usedServiceIcon [

	<script: 'self usedServiceIcon inspect'>
	^ self icons at: #usedService ifAbsentPut: [
		  Form fromBinaryStream:
			  self usedServiceIconEncoding base64Decoded readStream ]
]

{ #category : #accessing }
MolShapeIcon class >> usedServiceIconEncoding [

	^ 'iVBORw0KGgoAAAANSUhEUgAAACUAAABECAYAAAAGNvz8AAAAAXNSR0IArs4c6QAACTVJREFU
aEPt2WtQU9kdAPBzAeMS8EGVh8Tw3LQ8RmTppGBQXMNDRCKGsigwuI4gCKzijEgNyissjypM
RZBtAEEU0KYWV8CURMAuIMIwglUWx/IwCe8kIiSGhAS8ncsMM44jyU3Ih/1gvmVyzvn/8r/n
nnvu/0DgN/iBfoMm8AWF9qp8ydSXTKHNANp2KucUHo/nTU1N4devXw9ZWFgAHA732tHR8RmB
QOjz8vJqIBKJr9EG0qSdOhR/dHQUTyAQwMjICFhaWgLr1q0DSqUS6Onpga1bt8pIJFJjVFQU
g0KhtGgSWFVbdSje0tISdmJiwhSGYUggEJgNDQ3ZvXz5cuejR4982Gz2fqlUagzDMLCysho/
fvx4Np1O/2mtOLUosViMnZubM10tEIfD8aytrY2tra0NVSgUGCwWK6HRaFGpqan3tMWpRG3f
vp0rl8uNRCLRqqiVwFNTU0aVlZVncnNzL4jFYmNra+s3PB7va21gOkN9jEtLSyuoqqo6ubCw
ABITE5MLCwsLNMGpRSmVSqPp6Wm1mfo0aEdHh0dYWNg/kBuFRCI96ezs3IMWphY1Pz9vNDMz
ozEKAYjF4i3h4eFVjY2NAfb29kPDw8O/RwNTicLhcDylUokVCARaoRAActfGxcUVl5WVxSFz
lMfj2amDqcsUT6FQrAm1AkhISPhbRUVFoqWl5Zvh4WF7rdcpOzs7nkgkMkYug7p/h+b3kydP
Xkcy5ufn928Oh3NwtT4qM2VqasqHIGirQCDAogmKpo2Xl1dHW1sbKSMj40JGRsblz/VRibKy
suK/e/cOJ5FI9NEERNvG1NR0UigUmgEAPjuuStS2bdsmBALBtt7eXgcXF5chCIKW0AZW1Y7F
YjkFBQW9dHR07H3x4gXx07YqUba2ttPj4+NmCoUCGBsbAzc3t8mgoKCi6OhoxqZNm2bWAgwO
Dq6uq6sLq6ioIJ84ceKXj8dSiUpJSaHz+XxbqVT6TU9Pj/PY2NhyXywWCyIiIv5eWlqaCEGQ
QlscBoORI5dyfHzcFjXq44bIesPlcq2rqqpOXb9+/bxIJNLD4XDvysvL/+zv7/9YG9ixY8cK
bt26lchkMl1CQ0MHVsbQ6sUBhmF9Go1WkJeXl6ivrw9u3rwZEhkZ+S9tYACARX9/f1ZTU9Oh
NaFWOjc3N++jUCityPeKioqgsLCwek1hbm5u7b29vbsAAAY6QSGDNDc3Ew8cONBpYGCw0N/f
j7O3t5/TBJafn787KSnpP6Wlpf4xMTHNSF+tLt+nQYuKik4lJSX9RCQSf+no6PhWExTSVk9P
b9HHx+cOh8OJ1BkKGYhEIrU9ffp0T0tLy24ymfxEE5i5ufm4Uqk0nJmZ+Z1OUSwWy/PQoUMd
AQEBjfX19RRNUAEBAZUsFivy8ePHX+3bt29RJ5dvBWBvb8/l8/nWo6OjxhYWFlK0MBqNdjY3
N7eAzWbv3L9/f79OUREREZV379493t7e7kMikVC/chUWFnonJiZyGAzG0djY2H/qFMVgMH6I
jY0tys/PL0lKSkpAmyk2m21LoVCGzp07l5qTk5OrUxSHw6H6+fnVXbx48WV2drYLWhSTyfxD
WFjYq8DAwAeDg4OHdYpqaGigUqnUuuTkZGlOTo4xWtT9+/ddQ0JCen19fVs5HI63TlEMBiMu
ISGhJCsri0ej0WzQohoaGrwpFEpzamrqZTqdfkmnqPj4+LqSkhJqa2vrX8hk8md3lZ+DlpeX
R0dHR5ddvXo16ezZswU6Rbm6usKvX78GY2NjVlu2bBlFm6kLFy5czsvLO89isagBAQE/6wzV
09PzJyKR2O3u7g66urr0IQj6gBZFpVIbWSzWwb6+vh1OTk66W6dCQkLa7t27t4fJZJ4ODQ0t
RgtC2tnZ2Sn4fP465B0TgiCZTjL18OHDwMDAwAYHBwcwMDCAgSBIiRY1ODhoSiAQBGQyeaSl
peVrCIJgnaA2b94Mz8/Pg7a2NrKHh4dGu9DKysqTUVFRpT/++CM9JSUlXScPZBsbm7GJiQlc
SkrKrYyMjO/RZmil3e7duzmdnZ2+fX19f9y5c2fvmlDV1dWecXFxjRKJZDONRrudk5PzPZJ6
TVHGxsYf8Hj8f1+9evXNmnaenp6erU+ePPkWg8FA+fn56adPn87SBhQfH//XkpKS87dv3z4a
GRnJRIWqqakhvH37Fjs2Nvbd8+fPSf39/fump6eXC7JkMrm/qKjoqLOz86+aZgdpPzk5aers
7Dy0uLj4QSwWm3w8hsqJbm1tDfN4PABBEMBgMAB5czl8+PBAcnLyD66urhpN6E/hZ86cYV67
du07Op2enpaWRkeNwuPx8OjoKKivrwcEAsHFwcHhV00WxdUy2N3dTfb09GwxMzMD4+PjGyAI
eq8RSiaTAZFIpJOlAwn8/v17i717904+e/YM1NXVZQcHB1/6FK+uZP1OIpEoZ2dnkQrJmj8w
DBuGh4fP37lzB4SHh4OamhpDCILkmqJmZDLZEpqStToxDMPrbty4oYiOjgZOTk6gu7t7YMOG
Dc6f66cuUzMLCwtLa6l5IkFhGP6KwWDITp06BUxMTEBHRwdwdnZeNbY6lGR2dlYpkUiW38e0
+SCXrKysbD4mJgZs3LgRNDU1gV27dtlAEMRbbTx1qDG5XI4VCoVaoWAYNr906dJUdnb2Mqi5
uRns2LHDztDQ8I2qP6gOxZfL5YZCoVDjkjWXyz0YGRnZ2N7eDpBb/8GDB8DDwwPVDkIdiieT
ybCaTHQYhtcXFxfLs7KygEAgAL6+vqC6uhqYm5ujXlbU1dG5c3NzRhKJBFWmmEzmkczMzLsD
AwPAwMAAZGZmguTk5EADA4OHmsxHdY8ZrlQqNUIquas9cCcmJrYymcz4K1euZAqFQoDUR48c
OQLy8vKO2tjY3Nem/KgSZWFhgRyD4EUiEQYAgOy5YaFQaDQyMrKrpaUlnM1mH+/q6lp+QCMn
pT4+PiA9PT3E3d3957VUklWikLOZ6elpKyqVCrhcLhgeHgYSiWT5uBZ5SCMnosgWODg4GCQk
JDhYWlr+T5stjEYrupWV1QhSHV7phNxFyHmytbU18Pb2vk4mk4ttbGwG15IVjVf0lQ7IkZiJ
icm0iYmJWBeZUDfpUd+m6gbS5e9fUGiz+SVTaDP1f4qv2vSaegFRAAAAAElFTkSuQmCC'
]
