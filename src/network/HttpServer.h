/*!
 * \brief Provide a HTTP server.
 *
 * \copyright Copyright (c) 2016-2022 Governikus GmbH & Co. KG, Germany
 */

#pragma once

#include "HttpRequest.h"
#include "PortFile.h"

#include <QMetaMethod>
#include <QSharedPointer>
#include <QTcpServer>
#include <QVector>

namespace governikus
{

class HttpServer
	: public QObject
{
	Q_OBJECT

	private:
		QVector<QSharedPointer<QTcpServer>> mServer;
		PortFile mPortFile;

		bool checkReceiver(const QMetaMethod& pSignal, HttpRequest* pRequest);

	public:
		static quint16 cPort;
		static QVector<QHostAddress> cAddresses;

		explicit HttpServer(quint16 pPort = HttpServer::cPort,
				const QVector<QHostAddress>& pAddresses = HttpServer::cAddresses);
		~HttpServer() override;

		[[nodiscard]] int boundAddresses() const;
		[[nodiscard]] bool isListening() const;
		[[nodiscard]] quint16 getServerPort() const;

	private Q_SLOTS:
		void onNewConnection();
		void onMessageComplete(HttpRequest* pRequest);

	Q_SIGNALS:
		void fireNewHttpRequest(const QSharedPointer<HttpRequest>& pRequest);
		void fireNewWebSocketRequest(const QSharedPointer<HttpRequest>& pRequest);
};

} // namespace governikus
