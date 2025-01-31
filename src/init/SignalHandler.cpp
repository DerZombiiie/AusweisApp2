/*
 * \copyright Copyright (c) 2014-2022 Governikus GmbH & Co. KG, Germany
 */

#include "SignalHandler.h"

#include <QCoreApplication>
#include <QLoggingCategory>

using namespace governikus;

Q_DECLARE_LOGGING_CATEGORY(system)


SignalHandler::SignalHandler()
	: mInit(false)
	, mAppController()
	, mQuit(false)
{
}


#if defined(Q_OS_WIN) && !defined(Q_OS_WINRT)
SignalHandler::~SignalHandler()
{
	SetConsoleCtrlHandler(nullptr, false);
}


#else
SignalHandler::~SignalHandler() = default;


#endif


void SignalHandler::init()
{
	if (!mInit)
	{
#if (defined(Q_OS_LINUX) && !defined(Q_OS_ANDROID)) || (defined(Q_OS_BSD4) && !defined(Q_OS_IOS))
		initUnix();
#elif defined(Q_OS_WIN) && !defined(Q_OS_WINRT)
		SetConsoleCtrlHandler(PHANDLER_ROUTINE(ctrlHandler), true);
#endif

		mInit = true;
	}
}


void SignalHandler::setController(AppController& pAppController)
{
	mAppController = &pAppController;
}


void SignalHandler::quit()
{
	mQuit = true;

	if (mAppController)
	{
		QMetaObject::invokeMethod(mAppController.data(), [this]{
				mAppController->doShutdown();
			}, Qt::QueuedConnection);
	}
	else
	{
		QCoreApplication::exit();
	}
}


bool SignalHandler::shouldQuit() const
{
	return mQuit;
}


#if !(defined(Q_OS_UNIX) && !defined(Q_OS_ANDROID) && !defined(Q_OS_IOS))
// A dummy is required for all platform since moc fails to handle some defines.
void SignalHandler::onSignalSocketActivated()
{
}


#endif
