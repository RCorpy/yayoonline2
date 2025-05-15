const CARDS = {			 #type,	price,+money, +health, effect
	"ANGUSTIAS": 	["azul",	1,	1,	-1, null],
	"ENRIQUETA":	["azul",	0,	1,	-1, null],
	"GERTRUDIS":	["verde",	0,	1,	1, null],
	"GREGORIO":		["verde",	0,	1,	1, null],
	"JEREMIAS":		["amarillo",	0,	1,	1, null],
	"LIBERTO":		["rojo",	0,	1,	0, null],
	"URSULA":		["rojo",	0,	1,	0, null],
	
	"DENTADURA_POSTIZA":	["spell", 1, 0, 1, null],
	"BOINA":			["spell", 1, 0, 1, null],
	"TACATACA":			["spell", 1, 0, 1, null],
	"PARTIDA_DE_PETANCA":	["spell", 1, 0, 1, null],
	"AUDIFONO":			["spell", 1, 0, 1, null],
	"SIESTA":			["spell", 0, 0, 1, null],
	"CONTAR_BATALLITAS":	["spell", 0, 0, 1, null],
	"PASEO_POKEMON_GO":	["spell", 0, 0, 1, null],
	"GOLISMEAR":		["spell", 0, 0, 1, null],
	"DESCUBRIR_TELENOVELA":["spell", 0, 0, 1, null],
	
	"DULCES":			["spell", 1, 0, -1, null],
	"CLASE_DE_ZUMBA":		["spell", 1, 0, -1, null],
	"FUMAR_A_ESCONDIDAS":	["spell", 1, 0, -1, null],
	"VER_LAS_NOTICIAS":	["spell", 0, 0, -1, null],
	"RECUERDO_DE_LA_GUERRA":["spell", 0, 0, -1, null],
	"PERDERSE_EN_EL_SUPER":	["spell", 0, 0, -1, null],
	
	"MARCAPASOS":	["spell", 2, 0, 2, null],
	"PROTESIS_DE_CADERA":	["spell", 2, 0, 2, null],
	"EXOESQUELETO":	["spell", 2, 0, 2, null],
	"SILLA_DE_RUEDAS":	["spell", 2, 0, 2, null],
	"CRUCERO":	["spell", 2, 0, 2, null],
	
	"AUTOMEDICACION":	["spell", 2, 0, -2, null],
	"MOVIL_4G":	["spell", 2, 0, -2, null],
	"PAGAR_TU_FUNERAL":	["spell", 2, 0, -2, null],
	
	"MONEDA_EN_CABINA":	["spell", 0, 1, 0, null],
	"DINERO_EN_PANTALON_VIEJO":	["spell", 0, 1, 0, null],
	"HUCHA_DEL_CERDITO":	["spell", 0, 1, 0, null],
	"MIRAR_DETRAS_DEL_SOFA":	["spell", 0, 1, 0, null],
	"VENDER_ACCIONES":	["spell", 0, 1, 0, null],
	"VENDER_ANTIGUEDAD":	["spell", 0, 1, 0, null],
	
	"AGUJERO_EN_EL_PANTALON":	["spell", 0, -1, 0, null],
	"LIMOSNA":	["spell", 0, -1, 0, null],
	"HIPOTECA_DE_LOS_HIJOS":	["spell", 0, -1, 0, null],
	"ESTRENAS_DE_NAVIDAD":	["spell", 0, -1, 0, null],
	"DIENTE_DE_ORO":	["spell", 0, -1, 0, null],
	"SEGURO_PRIVADO":	["spell", 0, -1, 0, null],
	
	"PISO_DE_ESTUDIANTES":	["propiedad", 0, 0, 0, null],
	"CASA_EN_LA_PLAYA":	["propiedad", 0, 0, 0, null],
	"TIERRAS_DE_CULTIVO":	["propiedad", 0, 0, 0, null],
	"CASA_DE_PUEBLO":	["propiedad", 0, 0, 0, null],
	"CABANYA_EN_EL_MONTE":	["propiedad", 0, 0, 0, null],
	"LUXUS_CARAVAN":	["propiedad", 0, 0, 0, null],
	
	"MUERTE_AL_NIETO":	["special", 0, 0, -1, "eliminar nieto"],
	"ELIMINA_UN_NIETO":	["special", 0, 0, -1, "eliminar nieto"],
	
	"BABY_SITTER":	["special", 2, 0, 0, "transferir nieto"], #transfiere nietos a otro jugador
	
	"NIETO_FAMOSO":	["nieto", 0, 3, 1, null],
	"NIETO_YOUTUBER":	["nieto", 0, 3, 1, null],
	"NIETO_NORMAL":	["nieto", 0, -1, 1, null],
	"NIETO_MEH":	["nieto", 0, -1, 1, null],
	"NIETO_COMUN":	["nieto", 0, -1, 1, null],
	"NIETO_AVIPAO":	["nieto", 0, -1, 0, null],
	"NIETO_AUSTERO":	["nieto", 0, 0, 1, null],
	"NIETO_VEGETARIANO":	["nieto", 0, 0, 1, "proteger planta"], #proteccion contra plantas
	"NIETO_DERROCHADOR":	["nieto", 0, -2, 1, null],
	"NIETO_PIJO":	["nieto", 0, -2, 1, null],
	
	"MUERTE_AL_GATO":	["special", 0, 0, -1, "eliminar mascota"],
	"MUERTE_AL_PERRO":	["special", 0, 0, -1, "eliminar mascota"],
	
	"PASEADOR_DE_PERROS": ["special", 0 ,0 ,0, "transferir mascota"], #transfiere mascotas a otro jugador
	
	"MASCOTA_COCODRILO":	["mascota", 0, -2, -1, "proteger nieto"], #protección contra nietos
	"MASCOTA_BOA_CONSTRICTOR":	["mascota", 0, -2, -1, "proteger nieto"], #protección contra nietos
	"MASCOTA_OCA":	["mascota", 0, -2, 1, null],
	"ACUARIO":	["mascota", 0, -1, 1, null],
	"NIETO_FURRY":	["mascota", 0, -1, 1, null],
	"MASCOTA_PERRO":	["mascota", 0, 0, 1, null],
	"MASCOTA_GATO":	["mascota", 0, 0, 1, null],
	"MASCOTA_HAMSTER":	["mascota", 0, 0, 1, null],
	"MASCOTA_BUHO":	["mascota", 0, 0, 1, null],
	"MASCOTA_TORTUGA":	["mascota", 0, 0, 1, null],
	
	"MUERTE_A_LA_HIERBA":	["special", 0, 0, -1, "eliminar planta"],
	"MUERTE_A_LA_HUERTA":	["special", 0, 0, -1, "eliminar planta"],
	
	"ABUELO_EN_LA_JUNGLA":	["special", 0, 0, 0, "transferir planta"], #transfiere plantas a otro jugador
	
	"PLANTA_PINO":	["planta", 0, 0, 1, null],
	"PLANTA_TULIPAN":	["planta", 0, 0, 1, null],
	"PLANTA_SAUCE_LLORON":	["planta", 0, 0, 1, null],
	"PLANTA_MARGARITA":	["planta", 0, 0, 1, null],
	"PLANTA_FLOR_DE_PLASTICO":	["planta", 0, 0, 1, null],
	"PLANTA_CARNIVORA":	["planta", 0, 0, 1, "proteger mascota"], #proteccion contra mascotas
	
	#nombre -> [color]
	
	"PLAGA_DE_PULGAS":["azul"],
	"EMAIL_PRINCIPE_NIGERIANO":["azul"],
	"INUNDACION":["azul"],
	"MODERNIZACION":["azul"],
	"BLACK_FRIDAY":["azul"],
	"VIRUS_ANIMAL":["azul"],
	"CONCURSO_BELLEZA_CANINA":["azul"],
	"INCENDIO_FORESTAL":["azul"],
	"EXTRATERRESTRES":["azul"],
	"NIETOS_DE_ERASMUS":["azul"],
	"HACK_ATTACK":["azul"],
	"EUROMILLONES":["azul"],
	"CLASE_DE_YOGA":["azul"],
	"GUARDERIAS":["azul"],
	"OLA_DE_CALOR":["azul"],
	"VISION_FUTURA":["azul"],
	"NAVIDAD":["azul"],
	"TERREMOTO":["azul"],
	"RAYOS_X":["azul"]
}

const TEST_DECK = [
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
	"NIETO_FAMOSO",
]

const FULL_DECK = [
	"DENTADURA_POSTIZA",
	"BOINA",
	"TACATACA",
	"PARTIDA_DE_PETANCA",
	"AUDIFONO",
	"SIESTA",
	"CONTAR_BATALLITAS",
	"PASEO_POKEMON_GO",
	"GOLISMEAR",
	"DESCUBRIR_TELENOVELA",
	
	"DULCES",
	"CLASE_DE_ZUMBA",
	"FUMAR_A_ESCONDIDAS",
	"VER_LAS_NOTICIAS",
	"RECUERDO_DE_LA_GUERRA",
	"PERDERSE_EN_EL_SUPER",
	
	"MARCAPASOS",
	"PROTESIS_DE_CADERA",
	"EXOESQUELETO",
	"SILLA_DE_RUEDAS",
	"CRUCERO",
	
	"AUTOMEDICACION",
	"MOVIL_4G",
	"PAGAR_TU_FUNERAL",
	
	"MONEDA_EN_CABINA",
	"DINERO_EN_PANTALON_VIEJO",
	"HUCHA_DEL_CERDITO",
	"MIRAR_DETRAS_DEL_SOFA",
	"VENDER_ACCIONES",
	"VENDER_ANTIGUEDAD",
	
	"AGUJERO_EN_EL_PANTALON",
	"LIMOSNA",
	"HIPOTECA_DE_LOS_HIJOS",
	"ESTRENAS_DE_NAVIDAD",
	"DIENTE_DE_ORO",
	"SEGURO_PRIVADO",
	
	"PISO_DE_ESTUDIANTES",
	"CASA_EN_LA_PLAYA",
	"TIERRAS_DE_CULTIVO",
	"CASA_DE_PUEBLO",
	"CABANYA_EN_EL_MONTE",
	"LUXUS_CARAVAN",
	
	"MUERTE_AL_NIETO",
	"ELIMINA_UN_NIETO",
	
	"BABY_SITTER", #transfiere nietos a otro jugador
	
	"NIETO_FAMOSO",
	"NIETO_YOUTUBER",
	"NIETO_NORMAL",
	"NIETO_MEH",
	"NIETO_COMUN",
	"NIETO_AVIPAO",
	"NIETO_AUSTERO",
	"NIETO_VEGETARIANO", #proteccion contra plantas
	"NIETO_DERROCHADOR",
	"NIETO_PIJO",
	
	"MUERTE_AL_GATO",
	"MUERTE_AL_PERRO",
	
	"PASEADOR_DE_PERROS", #transfiere mascotas a otro jugador
	
	"MASCOTA_COCODRILO", #protección contra nietos
	"MASCOTA_BOA_CONSTRICTOR", #protección contra nietos
	"MASCOTA_OCA",
	"ACUARIO",
	"NIETO_FURRY",
	"MASCOTA_PERRO",
	"MASCOTA_GATO",
	"MASCOTA_HAMSTER",
	"MASCOTA_BUHO",
	"MASCOTA_TORTUGA",
	
	"MUERTE_A_LA_HIERBA",
	"MUERTE_A_LA_HUERTA",
	
	"ABUELO_EN_LA_JUNGLA", #transfiere plantas a otro jugador
	
	"PLANTA_PINO",
	"PLANTA_TULIPAN",
	"PLANTA_SAUCE_LLORON",
	"PLANTA_MARGARITA",
	"PLANTA_FLOR_DE_PLASTICO",
	"PLANTA_CARNIVORA" #proteccion contra mascotas
	]

const EVENT_DECK = [
	"PLAGA_DE_PULGAS", #El jugador con mas mascotas pierde su mano
	"EMAIL_PRINCIPE_NIGERIANO", #Email principe nigeriano, -2UPS todos
	"INUNDACION", #Terrenos a la mierda
	"MODERNIZACION", #Robar 2 cartas
	"BLACK_FRIDAY", #Todo cuesta 1 Up menos
	"VIRUS_ANIMAL", #Perder 1 EV por cada mascota (descartar todas las mascotas)
	"CONCURSO_BELLEZA_CANINA", #Por cada mascota se pierde 1 UP
	"INCENDIO_FORESTAL", #El jugador con mas plantas pierde su mano y sus plantas
	"EXTRATERRESTRES", #Eliminar nietos mascotas y plantas
	"NIETOS_DE_ERASMUS", #-1 UP por nieto
	"HACK_ATTACK", #Rotar manos
	"EUROMILLONES", #mas 2UP todos
	"CLASE_DE_YOGA", #El jugador con menos EV pierde turno (no gana UPS y no pierde EVS)
	"GUARDERIAS", #suben precio +1 up por nieto
	"OLA_DE_CALOR", #Perder 1 EV por cada planta
	"VISION_FUTURA", #Se da la vuelta a los proximos 2 eventos globales
	"NAVIDAD", #Roba una carta extra por cada nieto que tengas
	"TERREMOTO", #Todas las manos van al descarte. Cada uno roba 4 cartas y pierden 3 UPS (pierden terrenos)
	"RAYOS_X" #Se destapan las manos (durante toda la ronda)
]
