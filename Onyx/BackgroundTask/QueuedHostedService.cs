namespace Onyx.BackgroundTask
{
    public class QueuedHostedService(IBackgroundTaskQueue taskQueue) : BackgroundService
    {
        private readonly IBackgroundTaskQueue _taskQueue = taskQueue;

        protected override async Task ExecuteAsync(CancellationToken cancellationToken)
        {
            while (!cancellationToken.IsCancellationRequested)
            {
                var workItem = await _taskQueue.DequeueAsync(cancellationToken);
                await workItem(cancellationToken);
            }
        }
    }
}