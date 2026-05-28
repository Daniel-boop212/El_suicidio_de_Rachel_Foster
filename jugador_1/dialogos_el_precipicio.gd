extends RefCounted

const NPCS: Dictionary = {
	1: {
		"nombre": "Maya",
		"rol": "Mejor amiga de Rachel",
		"intro": "Llevamos cinco años siendo amigas. O eso creía yo.",
		"opciones": [
			{"texto": "¿Cuándo notaste que algo estaba mal con Rachel?", "respuesta": "Hace tres semanas. Dejó de contestar mis mensajes. Pensé que estaba enojada conmigo, pero luego vi su cara en la escuela... era otra persona.", "pista": "Rachel se aisló hace tres semanas"},
			{"texto": "¿Sabes si alguien le hacía daño?", "respuesta": "Derek y su grupo. Siempre con comentarios y burlas. Pero la semana pasada algo cambió. Se volvió peor. Creo que tiene que ver con una foto.", "pista": "Existe una foto comprometedora", "desbloquea": "Desbloquea preguntas con Camila.", "tarea": "perfil"},
			{"texto": "¿Rachel te dijo algo antes de irse al precipicio?", "respuesta": "Me mandó un mensaje que decía: Lo siento, nunca fui suficiente para nadie. Intenté llamarla pero no contestó.", "pista": "Mensaje de despedida a Maya"},
			{"texto": "¿Tú también la acosabas?", "respuesta": "¿Qué? No. Jamás. Pero... hubo una vez que me reí de un chiste que hicieron sobre ella. Ella lo vio. Nunca me perdoné eso.", "pista": "Maya la traicionó una vez"}
		]
	},
	2: {
		"nombre": "Profesor Torres",
		"rol": "Docente de Literatura",
		"intro": "Rachel era la mejor alumna que he tenido en diez años.",
		"opciones": [
			{"texto": "¿Notó cambios en Rachel en clase?", "respuesta": "Sus trabajos empezaron a llegar tarde. Sus textos se volvieron oscuros, llenos de metáforas sobre el vacío. Debí haber actuado antes."},
			{"texto": "¿Sabe de algún grupo de WhatsApp donde la molestaban?", "respuesta": "Un alumno lo mencionó de pasada. Dijo que había un grupo llamado El club de los inútiles. Rachel era el objetivo.", "pista": "Grupo de WhatsApp 'El club de los inútiles'", "desbloquea": "Desbloquea preguntas con Luis y Derek.", "tarea": "busqueda"},
			{"texto": "¿Reportó el acoso a la dirección?", "respuesta": "Lo intenté. Fui con el Director Méndez hace dos semanas. Me dijo que los chicos son así y que no había pruebas formales. Me arrepiento de no haber insistido.", "pista": "La dirección ignoró el caso", "desbloquea": "Desbloquea preguntas con el Director Méndez."},
			{"texto": "¿Rachel le dejó algo? ¿Un texto, una nota?", "respuesta": "Sí. Su último trabajo. El título era: Carta a nadie. No lo entendí hasta hoy.", "pista": "Carta a nadie - escrito de Rachel"}
		]
	},
	3: {
		"nombre": "Licenciada Vega",
		"rol": "Orientadora escolar",
		"intro": "Tengo el expediente de Rachel aquí. Vino a verme dos veces.",
		"opciones": [
			{"texto": "¿Qué le dijo Rachel cuando la visitó?", "respuesta": "La primera vez dijo que se sentía invisible. La segunda vez casi no habló. Solo preguntó si el dolor alguna vez se iba solo."},
			{"texto": "¿Notificó a los padres de Rachel?", "respuesta": "Llamé a la madre. Ella me dijo que Rachel estaba exagerando y que era una etapa. Eso me preocupó mucho.", "pista": "La madre minimizó la situación", "desbloquea": "Desbloquea preguntas con la mamá de Rachel."},
			{"texto": "¿Tiene información sobre los agresores?", "respuesta": "Sí, pero sin pruebas no pude actuar. Derek Salinas es el líder. Lo que me dijeron es que no solo era en persona; también era en redes sociales, de forma anónima.", "pista": "Acoso anónimo en redes", "desbloquea": "Desbloquea preguntas con Camila.", "tarea": "toxicidad"},
			{"texto": "¿Cree que Rachel llegará a hacerlo?", "respuesta": "Cuando alguien llega al borde, lo que más necesita saber es que alguien vio su dolor antes de que fuera demasiado tarde. Dígale eso.", "pista": "Clave psicológica para hablar con Rachel"}
		]
	},
	4: {
		"nombre": "Derek Salinas",
		"rol": "Acosador principal",
		"intro": "No hice nada. Era solo un juego.",
		"opciones": [
			{"texto": "¿Por qué elegiste a Rachel como objetivo?", "respuesta": "Ella se creía mejor que todos. Con sus libros, sus poemas... alguien tenía que bajarle el ego."},
			{"texto": "Tenemos pruebas del grupo, Derek.", "requiere": "Grupo de WhatsApp 'El club de los inútiles'", "respuesta": "Está bien. Sí. Yo creé el grupo. Pero nunca pensé que ella lo tomaría tan en serio. Era solo... broma.", "pista": "Derek admitió el grupo"},
			{"texto": "¿Tú publicaste la foto de Rachel?", "requiere": "Existe una foto comprometedora", "respuesta": "No fui yo. Fue Sofía. Yo solo... no la detuve.", "pista": "Sofía publicó la foto, Derek lo permitió", "desbloquea": "Desbloquea preguntas con Sofía.", "tarea": "testimonio"},
			{"texto": "¿Tienes algo que decirle a Rachel ahora mismo?", "respuesta": "Que... que lo siento. Que no sabía. Que soy un cobarde.", "pista": "Derek se arrepiente"}
		]
	},
	5: {
		"nombre": "Luis Paredes",
		"rol": "Cómplice del acosador",
		"intro": "Yo solo seguía la corriente, ¿okay? No era el líder.",
		"opciones": [
			{"texto": "¿Qué pasaba en el grupo El club de los inútiles?", "requiere": "Grupo de WhatsApp 'El club de los inútiles'", "respuesta": "Mandaban memes de Rachel, capturas de sus redes, se burlaban de cómo hablaba, de su ropa... era todos los días. Sin parar.", "pista": "Acoso diario y sistemático", "tarea": "moderacion"},
			{"texto": "¿Participabas en los mensajes del grupo?", "respuesta": "A veces ponía un emoji. Nada más. Sé que suena a excusa. Pero hay algo que vi que nadie más sabe."},
			{"texto": "¿Qué es lo que viste y nadie más sabe?", "respuesta": "La semana pasada Rachel le pidió a Derek que parara, frente a todos. Él se rio. Todos se rieron. Yo también. Ese día ella se fue llorando y nadie hizo nada.", "pista": "Rachel pidió que pararan y fue humillada públicamente"},
			{"texto": "¿Dónde estabas cuando Rachel fue al precipicio?", "respuesta": "La vi pasar corriendo esta mañana. Intenté decirle algo pero no pude. Soy un cobarde.", "pista": "Luis la vio esta mañana"}
		]
	},
	6: {
		"nombre": "Sofía Ríos",
		"rol": "Acosadora / publicó la foto",
		"intro": "No me mires así. No sabes nada.",
		"opciones": [
			{"texto": "¿Por qué publicaste la foto de Rachel?", "requiere": "Sofía publicó la foto, Derek lo permitió", "respuesta": "Porque me caía mal, ¿okay? Siempre tan perfecta. Con sus amigos, su familia, sus notas. Yo no tengo nada de eso."},
			{"texto": "¿Qué había en esa foto?", "respuesta": "Era una foto de Rachel llorando en clase. Alguien la tomó sin que ella lo supiera y me la mandaron. La subí a un grupo de 200 personas. No pensé que se viralizaría.", "pista": "La foto era de Rachel llorando, vista por 200 personas", "tarea": "perfil"},
			{"texto": "¿Sentiste algo cuando viste la reacción de Rachel?", "respuesta": "Sí. Pero tenía miedo de admitirlo frente a Derek y los demás. Si mostraba debilidad, la siguiente era yo.", "pista": "Sofía también tenía miedo de ser la siguiente víctima"},
			{"texto": "¿Qué harías diferente?", "respuesta": "No publicarla. Borrarla. Decirle a Rachel que lo siento. Que yo también estaba rota por dentro.", "pista": "Sofía está dispuesta a disculparse"}
		]
	},
	7: {
		"nombre": "Señora Chen",
		"rol": "Vecina de Rachel",
		"intro": "Esa niña siempre me traía flores del jardín cuando era pequeña.",
		"opciones": [
			{"texto": "¿Notó algo raro en Rachel últimamente?", "respuesta": "Llegaba a casa muy tarde. A veces se sentaba en el jardín sola y no hablaba. Una noche la escuché llorar desde mi ventana."},
			{"texto": "¿Habló con ella sobre lo que le pasaba?", "respuesta": "Intenté. Me dijo: Señora Chen, ¿usted cree que la gente cambia? Le dije que sí. Me respondió: Ojalá.", "pista": "Rachel dudaba de que las cosas pudieran cambiar"},
			{"texto": "¿Conoce a sus amigos o a quienes la molestaban?", "respuesta": "Vi a unos chicos frente a su casa una tarde, gritando cosas desde un carro. Rachel estaba en la ventana. Los vio y cerró las cortinas."},
			{"texto": "¿Tiene algo que quisiera que Rachel supiera?", "respuesta": "Que la he visto crecer. Que es la persona más valiente que conozco. Y que el jardín no sería igual sin ella.", "pista": "Mensaje de la Sra. Chen para Rachel"}
		]
	},
	8: {
		"nombre": "Pablo Mora",
		"rol": "Compañero neutral de clase",
		"intro": "Yo no me metía en nada. Solo observaba.",
		"opciones": [
			{"texto": "¿Qué observaste sobre el trato hacia Rachel?", "respuesta": "Todo. Era imposible no verlo. Pero nadie hacía nada. Yo tampoco."},
			{"texto": "¿Hubo algún momento específico que recuerdes?", "respuesta": "El día que le vaciaron el morral en el pasillo. Todos sus libros y cuadernos quedaron en el suelo. Derek lo filmó. Rachel se agachó a recogerlos sola.", "pista": "Incidente del morral - filmado por Derek"},
			{"texto": "¿Por qué no hiciste nada?", "respuesta": "Porque tenía miedo. Porque soy del mismo salón que Derek. Y porque una vez que alguien le ayudó a Rachel, al día siguiente era el nuevo objetivo.", "pista": "Quien la defendía también era atacado"},
			{"texto": "¿Qué le dirías a Rachel si pudieras?", "respuesta": "Que no estaba sola aunque pareciera que sí. Que yo la veía. Que debí haber dicho algo."}
		]
	},
	9: {
		"nombre": "Señor Kim",
		"rol": "Bibliotecario",
		"intro": "Rachel pasaba horas aquí. Era su refugio.",
		"opciones": [
			{"texto": "¿Qué hacía Rachel en la biblioteca?", "respuesta": "Leía, escribía en su diario. A veces solo se sentaba y respiraba. Una vez me dijo que aquí era el único lugar donde no se sentía juzgada.", "pista": "La biblioteca era su refugio"},
			{"texto": "¿Le preocupó su estado en algún momento?", "respuesta": "La última vez que vino, hace cuatro días, dejó olvidado su diario. Lo guardé para devolvérselo.", "pista": "Diario de Rachel", "tarea": "busqueda"},
			{"texto": "¿Puedo ver el diario?", "requiere": "Diario de Rachel", "respuesta": "La última entrada dice: Si mañana no estoy, al menos los libros recordarán que existí.", "pista": "Última entrada del diario", "tarea": "conversacion"},
			{"texto": "¿Qué libros leía Rachel?", "respuesta": "Muchos sobre resiliencia, sobre sobrevivir. Pero últimamente pedía libros sobre despedidas. No lo entendí en ese momento."}
		]
	},
	10: {
		"nombre": "Valentina Cruz",
		"rol": "Ex-amiga que la abandonó",
		"intro": "Sé lo que hice. No necesitas recordármelo.",
		"opciones": [
			{"texto": "¿Por qué dejaste de ser amiga de Rachel?", "respuesta": "Porque Derek me dijo que si seguía con ella, me harían lo mismo. Y tuve miedo. Elegí mal."},
			{"texto": "¿Cómo reaccionó Rachel cuando la abandonaste?", "respuesta": "Me mandó un mensaje que decía: ¿Tú también? Y yo no contesté. Ese silencio mío fue la peor crueldad que pude hacer.", "pista": "El abandono de Valentina fue un golpe definitivo para Rachel"},
			{"texto": "¿Intentaste reconectar con ella después?", "respuesta": "Sí. Dos semanas después. Fui a su casa. Ella abrió la puerta, me miró y la cerró. No la culpo."},
			{"texto": "¿Qué le dirías ahora mismo?", "respuesta": "Que fui una cobarde. Que ella valía más que mi miedo. Que espero que tenga la oportunidad de odiarme en persona por muchos años más.", "pista": "Valentina quiere que Rachel viva para perdonarla o no"}
		]
	},
	11: {
		"nombre": "Coach Ruiz",
		"rol": "Profesor de Educación Física",
		"intro": "En el deporte, aprendo a leer a las personas. Y a Rachel la leí tarde.",
		"opciones": [
			{"texto": "¿Notó algo en Rachel durante las clases?", "respuesta": "Se volvió más lenta, más distraída. Antes corría como si le encantara. Últimamente corría como si huyera de algo."},
			{"texto": "¿Hubo incidentes de acoso en sus clases?", "respuesta": "Una vez escuché a Derek imitar su voz. Lo mandé a dirección. No pasó nada.", "pista": "Reportes ignorados por la dirección - patrón confirmado"},
			{"texto": "¿Habló con Rachel alguna vez?", "respuesta": "Sí. Le pregunté si estaba bien. Me dijo: Coach, ¿alguna vez sintió que correr no era suficiente para escapar? No supe qué responderle."},
			{"texto": "¿Tiene algún mensaje para ella?", "respuesta": "Que los mejores corredores no son los más rápidos. Son los que no se rinden en la vuelta más difícil."}
		]
	},
	12: {
		"nombre": "Director Méndez",
		"rol": "Director del colegio",
		"intro": "Esta institución tiene protocolos. Seguimos todos los procedimientos.",
		"opciones": [
			{"texto": "¿Recibió reportes de acoso contra Rachel?", "requiere_alguna": ["La dirección ignoró el caso", "Reportes ignorados por la dirección - patrón confirmado"], "respuesta": "Recibimos... comentarios. Pero sin pruebas documentadas no podemos actuar formalmente."},
			{"texto": "La orientadora y el profesor reportaron. Usted los ignoró.", "requiere_alguna": ["La dirección ignoró el caso", "Reportes ignorados por la dirección - patrón confirmado"], "respuesta": "Cometí un error. Un error grave.", "pista": "La institución falló a Rachel - admisión del director"},
			{"texto": "¿Tomará medidas contra los agresores?", "respuesta": "Sí. Hoy mismo. Aunque sé que para Rachel puede que sea demasiado tarde. Eso... lo cargaré."},
			{"texto": "¿Tiene algo que decirle a Rachel?", "respuesta": "Que el sistema que debía protegerla le falló. Y que eso no fue su culpa. Nunca fue su culpa.", "pista": "La institución reconoce que falló - no fue culpa de Rachel"}
		]
	},
	13: {
		"nombre": "Alex Reyes",
		"rol": "Amigo cercano / interés romántico",
		"intro": "Yo la quería. No sé si ella lo sabía.",
		"opciones": [
			{"texto": "¿Cómo era tu relación con Rachel?", "respuesta": "Éramos amigos. Pero yo sentía algo más. Y creo que ella también. Pero nunca lo dijimos.", "pista": "Alex tenía sentimientos por Rachel, nunca expresados"},
			{"texto": "¿Sabías del acoso que sufría?", "respuesta": "Sí. Y lo peor es que una vez intenté defenderla y Rachel me pidió que no lo hiciera. Me dijo: No quiero que te lastimen por mí.", "pista": "Rachel protegía a otros antes que a sí misma"},
			{"texto": "¿Hablaste con ella sobre cómo se sentía?", "respuesta": "Hace una semana me mandó un mensaje a las 3am: Alex, ¿crees que soy una carga para todos? Le respondí que no. Pero debí hacer más.", "pista": "Rachel se sentía como una carga"},
			{"texto": "¿Qué le dirías si estuvieras aquí?", "respuesta": "Que la quiero. Que siempre la quise. Que el mundo es diferente con ella en él.", "pista": "Mensaje de Alex para Rachel"},
			{"texto": "¿no recuerdas algo importante?", "respuesta": "recuerdo que dijo algo sobre el acantilado que esta abajo a la derecha", "pista": "acantilado abajo"}
		]
	},
	14: {
		"nombre": "Camila Fuentes",
		"rol": "Testigo en redes sociales",
		"intro": "Yo vi todo lo que pasó online. Y lo guardé. Por si alguien preguntaba algún día.",
		"opciones": [
			{"texto": "¿Qué viste en redes sociales sobre Rachel?", "requiere_alguna": ["Existe una foto comprometedora", "Acoso anónimo en redes"], "respuesta": "Comentarios anónimos en sus publicaciones. Cosas horribles, diciéndole que era fea, que no servía para nada, que el mundo estaría mejor sin ella.", "pista": "Mensajes anónimos diciéndole que el mundo estaría mejor sin ella", "tarea": "toxicidad"},
			{"texto": "¿Sabes quién estaba detrás de las cuentas anónimas?", "respuesta": "Sí. Una era de Derek. Otra era de Sofía. Tengo capturas de pantalla.", "pista": "Capturas de pantalla como evidencia", "tarea": "busqueda"},
			{"texto": "¿Interactuaste con Rachel en redes?", "respuesta": "Una vez le comenté que era valiente por seguir publicando. Me respondió: Ya no sé cuánto tiempo puedo serlo. Eso me heló la sangre.", "pista": "Rachel admitió que estaba agotada de ser fuerte"},
			{"texto": "¿Por qué no reportaste el acoso online?", "respuesta": "Lo hice. Tres veces. Las plataformas tardaron semanas en responder. Para entonces el daño ya estaba hecho.", "pista": "El sistema de reporte online también falló"}
		]
	},
	15: {
		"nombre": "Tomás García",
		"rol": "Hermano menor de Rachel",
		"intro": "¿Mi hermana va a estar bien?",
		"opciones": [
			{"texto": "¿Notaste que algo le pasaba a Rachel?", "respuesta": "Lloraba en su cuarto pensando que no la escuchaba. Pero yo sí. Le golpeaba la puerta y me decía que estaba bien."},
			{"texto": "¿Hablaron sobre cómo se sentía?", "respuesta": "Una noche me abrazó muy fuerte y me dijo: Tomás, tú eres lo mejor que me pasó. Me pareció raro porque no era su cumpleaños ni nada.", "pista": "Rachel se despidió de Tomás sin que él lo supiera"},
			{"texto": "¿Qué hace Rachel cuando está feliz?", "respuesta": "Baila en la cocina cuando cocina. Me lee cuentos aunque ya soy grande. Siempre me recuerda que soy su persona favorita.", "pista": "Las cosas que Rachel ama - su hermano, los cuentos, bailar"},
			{"texto": "¿Tienes algo que quieras que sepa Rachel?", "respuesta": "Que sin ella no tengo quién me lea cuentos. Que la necesito. ¿Se lo puedes decir?", "pista": "Mensaje de Tomás - el más poderoso del juego"}
		]
	},
	16: {
		"nombre": "Don Héctor",
		"rol": "Dueño del café donde iba Rachel",
		"intro": "Pedía lo mismo siempre: chocolate caliente sin azúcar. Decía que la vida ya era suficientemente amarga.",
		"opciones": [
			{"texto": "¿Cuándo fue la última vez que la vio?", "respuesta": "Ayer. Estuvo dos horas sentada. Pidió su chocolate, escribió algo en una servilleta y la dejó en la mesa.", "pista": "Rachel dejó algo escrito en el café"},
			{"texto": "¿Guardó lo que escribió en la servilleta?", "requiere": "Rachel dejó algo escrito en el café", "respuesta": "Sí. Dice: Ojalá alguien hubiera preguntado cómo estaba. No que si estaba bien. Sino cómo estaba de verdad.", "pista": "Lo que Rachel necesitaba: que alguien preguntara de verdad"},
			{"texto": "¿Hablaba con usted Rachel?", "respuesta": "Poco. Pero un día me preguntó si uno puede volverse invisible. Le dije que no. Que aunque no la viéramos, ahí estaba. Me sonrió por primera vez en semanas.", "pista": "Una pequeña sonrisa - Rachel aún responde a la bondad"},
			{"texto": "¿Tiene algo que decirle?", "respuesta": "Que su chocolate la espera. Que el de mañana también. Y el del día siguiente."}
		]
	},
	17: {
		"nombre": "Pixel",
		"rol": "Amigo online de Rachel",
		"intro": "La conocí en un foro de escritura. Era la persona más increíble que jamás leí.",
		"opciones": [
			{"texto": "¿Cómo era Rachel en el mundo online?", "respuesta": "Completamente diferente. Libre. Escribía poemas, historias, ayudaba a otros. Online era quien quería ser en persona.", "pista": "Rachel online era valiente, ayudaba a otros en crisis"},
			{"texto": "¿Te contó sobre el acoso?", "respuesta": "Sí. Me dijo que en la escuela la hacían sentir que no existía. Que era raro porque online sentía que existía demasiado."},
			{"texto": "¿Notaste señales de alerta?", "respuesta": "Hace dos semanas dejó de publicar. Me respondió: Pixel, ¿crees que las historias siempre necesitan final? Me asusté y le dije que no.", "pista": "Rachel preguntó si las historias necesitan final"},
			{"texto": "¿Qué le dirías?", "respuesta": "Que miles de personas leyeron sus palabras y les cambiaron la vida. Que su historia no puede terminar porque todavía hay capítulos que no escribió.", "pista": "Rachel impactó a otros sin saberlo"}
		]
	},
	18: {
		"nombre": "Ernesto Silva",
		"rol": "Conserje del colegio",
		"intro": "Yo veo todo. Los conserjes siempre vemos todo.",
		"opciones": [
			{"texto": "¿Qué vio en el colegio sobre Rachel?", "respuesta": "La vi llorar en el baño más veces de las que debería. La vi recoger sus cosas del suelo cuando le tiraban las mochilas. La vi fingir que estaba bien."},
			{"texto": "¿Hubo algún momento que le haya quedado grabado?", "respuesta": "Una mañana la encontré en las escaleras traseras antes de que abrieran. Me dijo que estaba ensayando cómo entrar como si nada.", "pista": "Rachel ensayaba cómo fingir estar bien cada día"},
			{"texto": "¿Le dijo algo a Rachel alguna vez?", "respuesta": "Siempre le decía buenos días. Ella siempre me respondía. A veces era la única persona que le hablaba sin querer lastimarla.", "pista": "Los pequeños gestos importaban para Rachel"},
			{"texto": "¿Qué le diría si pudiera?", "respuesta": "Que los buenos días que me daba siempre alegraban mi mañana. Que ella no sabe el bien que hacía sin darse cuenta."}
		]
	},
	19: {
		"nombre": "Señora García",
		"rol": "Madre de Rachel",
		"intro": "Yo... yo no sabía. No sabía cuánto.",
		"opciones": [
			{"texto": "¿Cuándo notó que algo estaba mal?", "respuesta": "Hace meses. Pero me convencí de que era adolescencia. Que exageraba. Que se le pasaría.", "pista": "La madre se reprocha no haber actuado"},
			{"texto": "La orientadora la llamó. ¿Por qué no actuó?", "requiere": "La madre minimizó la situación", "respuesta": "Porque tenía miedo de que fuera verdad. Porque si era verdad, significaba que yo había fallado como madre. Y no pude con eso. Elegí negarme.", "pista": "La madre admite que el miedo la paralizó"},
			{"texto": "¿Qué relación tienen Rachel y su hermano Tomás?", "respuesta": "Rachel vive para Tomás. Siempre dijo que él era la razón por la que quería ser mejor. Por la que quería estar bien.", "pista": "Tomás es el ancla de Rachel"},
			{"texto": "¿Qué le diría a Rachel ahora mismo?", "respuesta": "Que lo siento. Que la vi pero no la escuché. Que soy su madre y la amo más que a nada. Que si me da una oportunidad, seré diferente.", "pista": "Mensaje de la madre - promesa de cambio"}
		]
	},
	20: {
		"nombre": "Rachel García",
		"rol": "Diálogo final en el precipicio",
		"intro": "No te acerques. Por favor.",
		"tarea_inicio": "conversacion",
		"opciones": [
			{"texto": "Rachel... ¿cómo estás de verdad?", "requiere": "Lo que Rachel necesitaba: que alguien preguntara de verdad", "respuesta": "Rachel se congela. Nadie... nadie me había preguntado eso así.", "pista_final": "Lo que Rachel necesitaba: que alguien preguntara de verdad"},
			{"texto": "Leí tu carta. Carta a nadie. Yo soy alguien.", "requiere": "Carta a nadie - escrito de Rachel", "respuesta": "¿La encontraste? Eso era para... no era para que nadie lo leyera. Le respondes que importa porque ella importa.", "pista_final": "Carta a nadie - escrito de Rachel"},
			{"texto": "Tomás me pidió que te dijera algo.", "requiere": "Mensaje de Tomás - el más poderoso del juego", "respuesta": "Rachel cierra los ojos. Le dices que sin ella Tomás no tiene quién le lea cuentos. Sus rodillas tiemblan.", "pista_final": "Mensaje de Tomás - el más poderoso del juego"},
			{"texto": "Vi tu diario. La última entrada.", "requiere": "Última entrada del diario", "respuesta": "Le dices que no serán los libros quienes recuerden que existió. Tú la recordarás. Ella escucha.", "pista_final": "Última entrada del diario"},
			{"texto": "Derek lo admitió. Se arrepiente.", "requiere": "Derek se arrepiente", "respuesta": "Rachel dice que su arrepentimiento no borra el dolor. Le das la razón: él está roto por lo que hizo, pero ella nunca fue el problema.", "pista_final": "Derek se arrepiente"},
			{"texto": "Aquí hay capturas. Pruebas. Se va a hacer justicia.", "requiere": "Capturas de pantalla como evidencia", "respuesta": "Rachel pregunta para qué sirve la justicia ahora. Le dices que puede evitar que otra persona pase por lo mismo.", "pista_final": "Capturas de pantalla como evidencia", "tarea": "busqueda"},
			{"texto": "Alex me dijo que te quiere. Nunca te lo dijo, ¿verdad?", "requiere": "Mensaje de Alex para Rachel", "respuesta": "Rachel abre los ojos. Le dices que el mundo es diferente con ella en él. Por un segundo aparece la duda.", "pista_final": "Mensaje de Alex para Rachel"},
			{"texto": "Pixel dice que tu historia no puede terminar aquí.", "requiere": "Rachel impactó a otros sin saberlo", "respuesta": "Le cuentas que miles de personas leyeron sus palabras y que aún quedan capítulos que no escribió.", "pista_final": "Rachel impactó a otros sin saberlo"}
		]
	}
}

static func obtener_npc(npc_id: int) -> Dictionary:
	return NPCS.get(npc_id, {})
