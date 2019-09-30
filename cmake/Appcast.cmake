IF(MAC OR LINUX OR WIN32)
	IF(JENKINS_APPCAST)
		SET(APPCAST_URL ${REMOTE_CONFIG_URL}/build CACHE STRING "Appcast download URL" FORCE)
	ELSE()
		SET(APPCAST_URL ${REMOTE_CONFIG_URL} CACHE STRING "Appcast download URL" FORCE)
	ENDIF()

	MACRO(ADD_APPCAST_FILE _files _system)
		SET(HASHFILE_ENDING "sha256")
		STRING(TIMESTAMP APPCAST_DATE "%Y-%m-%dT%H:%M:%S")

		FOREACH(filePath ${_files})
			IF(CMAKE_VERSION VERSION_LESS "3.14")
				FILE_SIZE(fileSize ${filePath})
			ELSE()
				FILE(SIZE ${filePath} fileSize)
			ENDIF()
			GET_FILENAME_COMPONENT(file ${filePath} NAME)

			IF(NOT DEFINED fileSize)
				MESSAGE(FATAL_ERROR "Cannot get file size of: ${file}")
			ENDIF()

			MESSAGE(STATUS "Processing: ${file}")
			IF(NOT "${_system}" STREQUAL "src")
				FILE(READ ${PACKAGING_DIR}/updater/Appcast.item.json.in item)

				STRING(REPLACE "AusweisApp2-" "" APPCAST_FILE_VERSION ${file})
				STRING(REPLACE ".dmg" "" APPCAST_FILE_VERSION ${APPCAST_FILE_VERSION})
				STRING(REPLACE ".msi" "" APPCAST_FILE_VERSION ${APPCAST_FILE_VERSION})

				STRING(REPLACE "APPCAST_DATE" "${APPCAST_DATE}" item ${item})
				STRING(REPLACE "APPCAST_PLATFORM" ${_system} item ${item})
				STRING(REPLACE "APPCAST_VERSION" "${APPCAST_FILE_VERSION}" item ${item})
				STRING(REPLACE "APPCAST_URL" "${APPCAST_URL}/${file}" item ${item})
				STRING(REPLACE "APPCAST_SIZE" "${fileSize}" item ${item})
				STRING(REPLACE "APPCAST_CHECKSUM" "${APPCAST_URL}/${file}.${HASHFILE_ENDING}" item ${item})
				STRING(REPLACE "APPCAST_NOTES" "${APPCAST_URL}/ReleaseNotes.html#${APPCAST_FILE_VERSION}" item ${item})

				SET(APPCAST_ITEMS "${APPCAST_ITEMS}${item},")
			ENDIF()

			FILE(SHA256 ${filePath} fileHash)
			FILE(WRITE ${filePath}.${HASHFILE_ENDING} "${fileHash}  ${file}\n")
		ENDFOREACH()
	ENDMACRO()

	IF(LINUX OR MAC)
		FILE(GLOB DMG_FILES ${PROJECT_BINARY_DIR}/*.dmg)
		FILE(GLOB MSI_FILES ${PROJECT_BINARY_DIR}/*.msi)
		FILE(GLOB TAR_GZ_FILES ${PROJECT_BINARY_DIR}/*.tar.gz)

		IF(DMG_FILES)
			ADD_APPCAST_FILE("${DMG_FILES}" "mac")
		ENDIF()

		IF(MSI_FILES)
			ADD_APPCAST_FILE("${MSI_FILES}" "win")
		ENDIF()

		IF(TAR_GZ_FILES)
			ADD_APPCAST_FILE("${TAR_GZ_FILES}" "src")
		ENDIF()

		IF(APPCAST_ITEMS)
			STRING(REGEX REPLACE ",$" "" APPCAST_ITEMS "${APPCAST_ITEMS}")
			CONFIGURE_FILE(${PACKAGING_DIR}/updater/Appcast.json.in ${PROJECT_BINARY_DIR}/Appcast.json @ONLY)
		ENDIF()
	ENDIF()

ENDIF()
