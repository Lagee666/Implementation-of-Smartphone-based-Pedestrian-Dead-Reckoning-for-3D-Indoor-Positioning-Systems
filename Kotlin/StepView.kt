package com.example.ntutmap

import android.content.Context
import android.graphics.*
import android.util.AttributeSet
import android.view.MotionEvent
import android.view.SurfaceHolder
import android.view.View

import java.util.*
import kotlin.collections.ArrayList

class StepView @JvmOverloads constructor(context: Context?, attrs: AttributeSet? = null, defStyleAttr: Int = 0) : View(context, attrs, defStyleAttr)  {
    private val mPaint: Paint = Paint()
    private val mStrokePaint: Paint
    private val mArrowPath // 箭头路径
            : Path
    private val cR = 5 // 圆点半径
    private val arrowR = 10 // 箭头半径
    private var mCurX = 0f
    private var mCurY = 0f
    private var xratio = 226.toFloat() / 1689.toFloat()
    private var yratio = 382.toFloat() / 2903.toFloat()
    private var mOrient = 0.0
    private var activity = 0
    private var touchview = 1

    private var mPointList2: MutableList<PointF> = ArrayList()
    private var mPointList3: MutableList<PointF> = ArrayList()
    private var mPointList4: MutableList<PointF> = ArrayList()

    private var mPointList: MutableList<PointF> = ArrayList()
    private val floorlist: MutableList<MutableList<PointF>> = mutableListOf(mPointList,mPointList,mPointList)
    override fun onDraw(canvas: Canvas) {
        if (canvas == null) return
//        if (activity == 1.0) {
        mPaint.color = Color.BLACK //h
//        }
//        if (activity == 2.0) {
//            mPaint.color = Color.GREEN //p
//        }
//        if (activity == 3.0) {
//            mPaint.color = Color.BLUE //p
//        }
        for (p in mPointList) {
            canvas.drawCircle(p.x, p.y, cR.toFloat(), mPaint)
        }
        canvas.save() // 保存画布
        canvas.translate(mCurX, mCurY) // 平移画布
        canvas.rotate(mOrient.toFloat()) // 转动画布
        canvas.drawPath(mArrowPath, mPaint)
        canvas.drawArc(RectF(-arrowR * 0.8f, -arrowR * 0.8f, arrowR * 0.8f, arrowR * 0.8f), 0f, 360f, false, mStrokePaint)
        canvas.restore() // 恢复画布

    }

    /**
     * 当屏幕被触摸时调用
     */
    override fun onTouchEvent(event: MotionEvent): Boolean {
        if (touchview == 1) {
            mCurX = event.x
            mCurY = event.y
           // println("$mCurX     $mCurY")
        }
        invalidate()
        return true
    }

    /**
     * 自动增加点
     */
    fun autoAddPoint(stepLen: Float, ratioh: Float, modenum: Int, runviewx: Float, runviewy: Float) {
        mCurX = runviewx
        mCurY = runviewy
        print(mPaint)
//        mPointList.add(new PointF(mCurX, mCurY));
        var activity_ratio = 0f;
        if (activity == 1) activity_ratio = 1f
        else if (activity == 2 || activity == 3) activity_ratio = 0.9f
        else activity_ratio = 1f
        mCurX = (mCurX + activity_ratio * xratio * ratioh * stepLen * Math.sin(Math.toRadians(mOrient))).toFloat()
        mCurY = (mCurY - activity_ratio * xratio * ratioh * stepLen * Math.cos(Math.toRadians(mOrient))).toFloat()         // yratio
        mPointList.add(PointF(mCurX, mCurY))
        activity = modenum
        invalidate()
    }

    fun autoDrawArrow(orient: Double) {
        mOrient = orient
        invalidate()
    }

    fun getviewx(): Float {
        return mCurX
    }

    fun getviewy(): Float {
        return mCurY
    }

    fun addstartpointflag(flag: Int) {
        touchview = flag
        invalidate()
    }

    fun addratio(x: Float) {
        xratio = 26.toFloat() / x
        yratio = 26.toFloat() / x
    }

    fun cleancanvas(new_floor: Float, old_floor: Float){

        when(old_floor){
            2.0f -> mPointList2 = mPointList.toMutableList()
            3.0f -> mPointList3 = mPointList.toMutableList()
            4.0f -> mPointList4 = mPointList.toMutableList()
        }
        mPointList.clear()
        when(new_floor){
            2.0f -> mPointList = mPointList2.toMutableList()
            3.0f -> mPointList = mPointList3.toMutableList()
            4.0f -> mPointList = mPointList4.toMutableList()
        }

        invalidate()
    }

    companion object {
        private const val TAG = "StepView"
    }

    init {

        // 初始化画笔
        mPaint.color = Color.BLACK
        mPaint.isAntiAlias = true
        mPaint.style = Paint.Style.FILL
        mStrokePaint = Paint(mPaint)
        mStrokePaint.style = Paint.Style.STROKE
        mStrokePaint.strokeWidth = 5f

        // 初始化箭头路径
        mArrowPath = Path()
        mArrowPath.arcTo(RectF((-arrowR).toFloat(), (-arrowR).toFloat(), arrowR.toFloat(), arrowR.toFloat()), 0f, -180f)
        mArrowPath.lineTo(0f, -3 * arrowR.toFloat())
        mArrowPath.close()


    }
}