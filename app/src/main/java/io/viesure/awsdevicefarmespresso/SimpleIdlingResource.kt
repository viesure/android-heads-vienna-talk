package io.viesure.awsdevicefarmespresso

import androidx.test.espresso.IdlingResource
import java.util.concurrent.atomic.AtomicBoolean

class SimpleIdlingResource : IdlingResource {

    private var callback: IdlingResource.ResourceCallback? = null

    private val isIdleNow = AtomicBoolean(true)

    override fun getName(): String {
        return this.javaClass.name
    }

    override fun isIdleNow(): Boolean = isIdleNow.get()

    override fun registerIdleTransitionCallback(callback: IdlingResource.ResourceCallback?) {
        this.callback = callback
    }

    fun setIdleState(isIdleNow: Boolean) {
        this.isIdleNow.set(isIdleNow)
        if (isIdleNow && callback != null) {
            callback?.onTransitionToIdle()
        }
    }
}