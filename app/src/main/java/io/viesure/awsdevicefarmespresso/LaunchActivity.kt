package io.viesure.awsdevicefarmespresso

import android.animation.Animator
import android.content.Intent
import android.os.Bundle
import androidx.appcompat.app.AppCompatActivity
import kotlinx.android.synthetic.main.activity_launch.*

class LaunchActivity : AppCompatActivity(), Animator.AnimatorListener {

    var idleResource = SimpleIdlingResource()

    override fun onCreate(savedInstanceState: Bundle?) {
        super.onCreate(savedInstanceState)
        setContentView(R.layout.activity_launch)
        lottie.addAnimatorListener(this)
    }

    override fun onAnimationRepeat(p0: Animator?) {

    }

    override fun onAnimationEnd(p0: Animator?) {
        startActivity(Intent(this, MainActivity::class.java))
        finish()
        idleResource.setIdleState(true)
    }

    override fun onAnimationCancel(p0: Animator?) {

    }

    override fun onAnimationStart(p0: Animator?) {
        idleResource.setIdleState(false)
    }
}
